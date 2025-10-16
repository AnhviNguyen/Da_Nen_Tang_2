import React from 'react';
import { Pressable, Text, PressableProps } from 'react-native';

type ButtonProps = PressableProps & {
  label: string;
  variant?: 'primary' | 'secondary' | 'ghost';
};

export function Button({ label, variant = 'primary', style, ...rest }: ButtonProps) {
  const base = {
    paddingVertical: 12,
    paddingHorizontal: 14,
    borderRadius: 16,
    alignItems: 'center' as const,
    justifyContent: 'center' as const,
  };
  const stylesByVariant = {
    primary: { backgroundColor: '#111827' },
    secondary: { backgroundColor: '#e5e7eb' },
    ghost: { backgroundColor: 'transparent' },
  } as const;
  const textByVariant = {
    primary: { color: '#fff' },
    secondary: { color: '#111827' },
    ghost: { color: '#111827' },
  } as const;

  return (
    <Pressable
      style={[base, stylesByVariant[variant], style]}
      android_ripple={{ color: '#00000022', borderless: false }}
      {...rest}
    >
      <Text style={[{ fontSize: 16, fontWeight: '600' }, textByVariant[variant]]}>{label}</Text>
    </Pressable>
  );
}


