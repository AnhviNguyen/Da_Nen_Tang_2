import React from 'react';
import { View, ViewProps } from 'react-native';

type CardProps = ViewProps & {
  children: React.ReactNode;
};

export function Card({ style, children, ...rest }: CardProps) {
  return (
    <View
      style={[
        {
          backgroundColor: 'rgba(255,255,255,0.9)',
          borderRadius: 20,
          padding: 12,
          shadowColor: '#000',
          shadowOpacity: 0.1,
          shadowRadius: 12,
          shadowOffset: { width: 0, height: 6 },
          elevation: 4,
        },
        style,
      ]}
      {...rest}
    >
      {children}
    </View>
  );
}


