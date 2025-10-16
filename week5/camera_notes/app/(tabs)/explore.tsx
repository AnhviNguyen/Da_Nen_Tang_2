import { Button } from '@/components/ui/button';
import { useMediaActions } from '@/hooks/useMedia';
import { usePhotoStorage } from '@/hooks/useStorage';
import { useFocusEffect } from 'expo-router';
import { useCallback, useMemo, useState } from 'react';
import { FlatList, Image, Modal, Pressable, RefreshControl, StyleSheet, Text, TextInput, View } from 'react-native';

export default function GalleryScreen() {
  const { photos, updateCaption, removePhoto, reload } = usePhotoStorage();
  const { saveToLibrary, share } = useMediaActions();
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const selected = useMemo(() => photos.find((p) => p.id === selectedId) || null, [photos, selectedId]);
  const [draft, setDraft] = useState('');
  const [refreshing, setRefreshing] = useState(false);

  useFocusEffect(
    useCallback(() => {
      // Reload when tab gains focus to reflect newly captured photos instantly
      reload();
      return () => {};
    }, [reload])
  );

  const onRefresh = useCallback(async () => {
    setRefreshing(true);
    await reload();
    setRefreshing(false);
  }, [reload]);

  return (
    <View style={{ flex: 1, backgroundColor: '#f3f4f6' }}>
      <FlatList
        data={photos}
        numColumns={2}
        keyExtractor={(item) => item.id}
        columnWrapperStyle={{ gap: 12, paddingHorizontal: 12 }}
        contentContainerStyle={{ gap: 12, paddingVertical: 12, paddingTop: 16 }}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
        renderItem={({ item }) => (
          <Pressable style={{ flex: 1 }} onPress={() => { setSelectedId(item.id); setDraft(item.caption); }}>
            <View style={styles.tile}>
              <Image source={{ uri: item.uri }} style={styles.tileImage} />
              <Text numberOfLines={1} style={styles.tileCaption}>{item.caption || ' '}</Text>
              <Pressable hitSlop={10} style={styles.starBtn}>
                <Text>☆</Text>
              </Pressable>
            </View>
          </Pressable>
        )}
        ListEmptyComponent={() => (
          <View style={{ padding: 24, alignItems: 'center' }}>
            <Text style={{ color: '#6b7280' }}>Chưa có ảnh. Hãy chụp ảnh ở tab Camera.</Text>
          </View>
        )}
      />

      <Modal visible={!!selected} transparent animationType="slide" onRequestClose={() => setSelectedId(null)}>
        <View style={styles.modalBackdrop}>
          <View style={styles.modalCard}>
            {selected && (
              <>
                <Image source={{ uri: selected.uri }} style={{ width: '100%', aspectRatio: 1, borderRadius: 12 }} />
                <TextInput
                  value={draft}
                  onChangeText={setDraft}
                  placeholder="Chỉnh sửa caption"
                  style={styles.input}
                  placeholderTextColor="#9ca3af"
                />
                <View style={{ flexDirection: 'row', gap: 8 }}>
                  <Button label="Lưu" onPress={async () => { await updateCaption(selected.id, draft); setSelectedId(null); }} />
                  <Button label="Xoá" variant="secondary" onPress={async () => { await removePhoto(selected.id); setSelectedId(null); }} />
                </View>
                <View style={{ height: 8 }} />
                <View style={{ flexDirection: 'row', gap: 8 }}>
                  <Button label="Lưu vào Thư viện" variant="ghost" onPress={async () => { await saveToLibrary(selected.uri); }} />
                  <Button label="Chia sẻ" variant="ghost" onPress={async () => { await share(selected.uri); }} />
                </View>
                <View style={{ height: 8 }} />
                <Button label="Đóng" variant="secondary" onPress={() => setSelectedId(null)} />
              </>
            )}
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  tile: {
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 8,
    overflow: 'hidden',
    shadowColor: '#000',
    shadowOpacity: 0.06,
    shadowRadius: 10,
    shadowOffset: { width: 0, height: 6 },
  },
  tileImage: { width: '100%', aspectRatio: 0.85, borderRadius: 12 },
  tileCaption: { marginTop: 8, color: '#374151', fontWeight: '600' },
  starBtn: { position: 'absolute', top: 12, right: 12, backgroundColor: '#fff', borderRadius: 12, paddingHorizontal: 6, paddingVertical: 2 },
  modalBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.6)',
    padding: 16,
    justifyContent: 'center',
  },
  modalCard: {
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 12,
    gap: 12,
  },
  input: {
    borderWidth: 1,
    borderColor: '#e5e7eb',
    borderRadius: 12,
    paddingHorizontal: 12,
    paddingVertical: 10,
    color: '#111827',
  },
});
