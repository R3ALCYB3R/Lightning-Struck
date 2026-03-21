import React, { useState } from 'react';
import { StyleSheet, Text, View, TouchableOpacity, ScrollView, SafeAreaView } from 'react-native';
import { StatusBar } from 'expo-status-bar';

export default function App() {
  const [status, setStatus] = useState('Waiting for LocalDevVPN...');
  const [jitEnabled, setJitEnabled] = useState(false);

  const handleTriggerJIT = () => {
    setStatus('Connecting to 127.0.0.1:62078...');
    // Logic for mounting DDI via LocalDevVPN loopback goes here
    setTimeout(() => {
      setJitEnabled(true);
      setStatus('JIT Successfully Enabled for System!');
    }, 2000);
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="light" />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        
        {/* Header Section */}
        <View style={styles.header}>
          <Text style={styles.title}>LocalJIT</Text>
          <Text style={styles.subtitle}>BY R3ALCYB3R</Text>
        </View>

        {/* Status Card */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>System Status</Text>
          <Text style={[styles.statusText, jitEnabled ? styles.success : styles.warning]}>
            {status}
          </Text>
        </View>

        {/* Main Action Button */}
        <TouchableOpacity 
          style={styles.neonButton} 
          onPress={handleTriggerJIT}
          activeOpacity={0.7}
        >
          <Text style={styles.buttonText}>INITIALIZE JIT TUNNEL</Text>
        </TouchableOpacity>

        {/* Pairing File Section */}
        <TouchableOpacity style={styles.secondaryButton}>
          <Text style={styles.secondaryButtonText}>Import .mobiledevicepairing</Text>
        </TouchableOpacity>

        <Text style={styles.footerText}>
          Ensure LocalDevVPN is active before initializing.
        </Text>

      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000000', // Deep black background
  },
  scrollContent: {
    alignItems: 'center',
    paddingTop: 50,
  },
  header: {
    marginBottom: 40,
    alignItems: 'center',
  },
  title: {
    fontSize: 42,
    fontWeight: '900',
    color: '#BF00FF', // Neon Purple
    textShadowColor: 'rgba(191, 0, 255, 0.75)',
    textShadowOffset: { width: 0, height: 0 },
    textShadowRadius: 15,
  },
  subtitle: {
    fontSize: 14,
    color: '#ffffff',
    letterSpacing: 4,
    marginTop: -5,
  },
  card: {
    width: '90%',
    backgroundColor: '#1a1a1a',
    borderRadius: 15,
    padding: 20,
    borderWidth: 1,
    borderColor: '#333',
    marginBottom: 30,
  },
  cardTitle: {
    color: '#888',
    fontSize: 12,
    textTransform: 'uppercase',
    marginBottom: 10,
  },
  statusText: {
    fontSize: 18,
    fontWeight: '600',
  },
  warning: { color: '#ffcc00' },
  success: { color: '#00ffcc', textShadowColor: '#00ffcc', textShadowRadius: 10 },
  neonButton: {
    width: '90%',
    height: 60,
    backgroundColor: '#BF00FF',
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#BF00FF',
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.8,
    shadowRadius: 20,
    marginBottom: 20,
  },
  buttonText: {
    color: '#ffffff',
    fontSize: 18,
    fontWeight: 'bold',
    letterSpacing: 1,
  },
  secondaryButton: {
    padding: 15,
  },
  secondaryButtonText: {
    color: '#BF00FF',
    fontSize: 14,
  },
  footerText: {
    color: '#444',
    fontSize: 12,
    marginTop: 40,
    textAlign: 'center',
    paddingHorizontal: 40,
  },
});
