export const STORAGE_KEYS = {
  photos: 'camera_notes/photos',
} as const;

export type StoredPhoto = {
  id: string;
  uri: string; // file path
  caption: string;
  createdAt: number; // epoch ms
};


