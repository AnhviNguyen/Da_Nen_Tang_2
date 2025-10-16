import { STORAGE_KEYS, type StoredPhoto } from '@/constants/storage';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as FileSystem from 'expo-file-system/legacy';
import { useCallback, useEffect, useState } from 'react';

function generateId() {
  return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
}

export function usePhotoStorage() {
  const [photos, setPhotos] = useState<StoredPhoto[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    (async () => {
      try {
        const raw = await AsyncStorage.getItem(STORAGE_KEYS.photos);
        const parsed: StoredPhoto[] = raw ? JSON.parse(raw) : [];
        setPhotos(parsed);
      } finally {
        setIsLoading(false);
      }
    })();
  }, []);

  const reload = useCallback(async () => {
    const raw = await AsyncStorage.getItem(STORAGE_KEYS.photos);
    const parsed: StoredPhoto[] = raw ? JSON.parse(raw) : [];
    setPhotos(parsed);
  }, []);

  const persist = useCallback(async (list: StoredPhoto[]) => {
    setPhotos(list);
    await AsyncStorage.setItem(STORAGE_KEYS.photos, JSON.stringify(list));
  }, []);

  const addPhoto = useCallback(
    async ({ tempUri, caption }: { tempUri: string; caption: string }) => {
      const id = generateId();
      const dir = FileSystem.documentDirectory + 'camera-notes';
      await FileSystem.makeDirectoryAsync(dir, { intermediates: true }).catch(() => {});
      const dest = `${dir}/${id}.jpg`;
      await FileSystem.copyAsync({ from: tempUri, to: dest });
      const next: StoredPhoto[] = [{ id, uri: dest, caption, createdAt: Date.now() }, ...photos];
      await persist(next);
      return id;
    },
    [photos, persist]
  );

  const updateCaption = useCallback(
    async (id: string, caption: string) => {
      const next = photos.map((p) => (p.id === id ? { ...p, caption } : p));
      await persist(next);
    },
    [photos, persist]
  );

  const removePhoto = useCallback(
    async (id: string) => {
      const target = photos.find((p) => p.id === id);
      const next = photos.filter((p) => p.id !== id);
      await persist(next);
      if (target) {
        // Best-effort delete stored file
        FileSystem.deleteAsync(target.uri, { idempotent: true }).catch(() => {});
      }
    },
    [photos, persist]
  );

  return { photos, isLoading, addPhoto, updateCaption, removePhoto, reload };
}


