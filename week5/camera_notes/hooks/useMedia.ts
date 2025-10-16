import { useCallback } from 'react';
import * as MediaLibrary from 'expo-media-library';
import * as Sharing from 'expo-sharing';

export function useMediaActions() {
  const requestMediaPermission = useCallback(async () => {
    const { status } = await MediaLibrary.requestPermissionsAsync();
    return status === 'granted';
  }, []);

  const saveToLibrary = useCallback(async (uri: string) => {
    const ok = await requestMediaPermission();
    if (!ok) return false;
    await MediaLibrary.saveToLibraryAsync(uri);
    return true;
  }, [requestMediaPermission]);

  const share = useCallback(async (uri: string) => {
    const isAvailable = await Sharing.isAvailableAsync();
    if (!isAvailable) return false;
    await Sharing.shareAsync(uri);
    return true;
  }, []);

  return { saveToLibrary, share, requestMediaPermission };
}


