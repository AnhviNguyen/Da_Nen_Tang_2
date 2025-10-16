import { Ionicons } from '@expo/vector-icons';
import { Tabs } from 'expo-router';
import React from 'react';

// Removed HapticTab: keep native tab behavior
import { Colors } from '@/constants/theme';
import { useColorScheme } from '@/hooks/use-color-scheme';

export default function TabLayout() {
  const colorScheme = useColorScheme();

  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: Colors[colorScheme ?? 'light'].tint,
        headerShown: false,
        // default tab button
      }}>
      <Tabs.Screen
        name="index"
        options={{
          title: 'Camera',
          tabBarIcon: ({ color, size }) => <Ionicons name="camera" color={color} size={size ?? 24} />,
        }}
      />
      <Tabs.Screen
        name="explore"
        options={{
          title: 'Gallery',
          tabBarIcon: ({ color, size }) => <Ionicons name="images" color={color} size={size ?? 24} />,
        }}
      />
    </Tabs>
  );
}
