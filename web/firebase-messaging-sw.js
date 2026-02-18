// Combined Service Worker for PWA + FCM
console.log('[SW] Service worker initializing...');

// Import Firebase scripts for messaging
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// PWA Cache Configuration
const CACHE_NAME = 'smart-parking-v1';
const RUNTIME_CACHE = 'runtime-cache-v1';

// Assets to precache
const PRECACHE_URLS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
];

// Initialize Firebase in service worker
firebase.initializeApp({
  apiKey: 'AIzaSyANCZYdkEH-8PKVt3IpBA10vNqeibqxOEw',
  authDomain: 'parking-app-ffe32.firebaseapp.com',
  projectId: 'parking-app-ffe32',
  storageBucket: 'parking-app-ffe32.firebasestorage.app',
  messagingSenderId: '473181664730',
  appId: '1:473181664730:web:470a50a74f81e1b6e33ce3',
  measurementId: 'G-2CFV7TQS1P'
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();

// ==================== PWA CACHING ====================

// Install event - cache essential assets
self.addEventListener('install', (event) => {
  console.log('[SW] 📦 Installing...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[SW] Precaching app shell');
        return cache.addAll(PRECACHE_URLS);
      })
      .then(() => {
        console.log('[SW] ✅ Install complete');
        return self.skipWaiting();
      })
      .catch((err) => {
        console.error('[SW] ❌ Install failed:', err);
      })
  );
});

// Activate event - cleanup old caches
self.addEventListener('activate', (event) => {
  console.log('[SW] 🔄 Activating...');
  event.waitUntil(
    caches.keys()
      .then((cacheNames) => {
        return Promise.all(
          cacheNames
            .filter((name) => name !== CACHE_NAME && name !== RUNTIME_CACHE)
            .map((name) => {
              console.log('[SW] Deleting old cache:', name);
              return caches.delete(name);
            })
        );
      })
      .then(() => {
        console.log('[SW] ✅ Activated');
        return self.clients.claim();
      })
  );
});

// Fetch event - serve from cache with network fallback
self.addEventListener('fetch', (event) => {
  // Skip non-GET requests
  if (event.request.method !== 'GET') return;
  
  // Skip cross-origin requests (except Firebase)
  const url = new URL(event.request.url);
  if (url.origin !== self.location.origin && 
      !url.hostname.includes('googleapis.com') &&
      !url.hostname.includes('firebaseapp.com')) {
    return;
  }

  // Network-first strategy for Firebase/API requests
  if (url.pathname.includes('/api/') || 
      url.hostname.includes('firestore.googleapis.com') ||
      url.hostname.includes('firebase')) {
    event.respondWith(
      fetch(event.request)
        .catch(() => caches.match(event.request))
    );
    return;
  }

  // Cache-first strategy for static assets
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        if (response) {
          return response;
        }
        return fetch(event.request)
          .then((response) => {
            if (!response || response.status !== 200) {
              return response;
            }
            const responseToCache = response.clone();
            caches.open(RUNTIME_CACHE)
              .then((cache) => cache.put(event.request, responseToCache));
            return response;
          })
          .catch(() => caches.match('/index.html'));
      })
  );
});

// Handle messages from clients
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

console.log('[SW] 🚀 Service worker loaded');

// ==================== FIREBASE MESSAGING ====================

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] 📨 Received background message');
  console.log('[firebase-messaging-sw.js]   Message ID:', payload.messageId);
  console.log('[firebase-messaging-sw.js]   Title:', payload.notification?.title);
  console.log('[firebase-messaging-sw.js]   Body:', payload.notification?.body);
  console.log('[firebase-messaging-sw.js]   Data:', payload.data);
  
  const notificationTitle = payload.notification?.title || 'Parking App';
  const notificationOptions = {
    body: payload.notification?.body || 'You have a new notification',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: payload.data?.type || 'notification-' + Date.now(),
    data: payload.data,
    requireInteraction: false,
    vibrate: [200, 100, 200],
  };

  console.log('[firebase-messaging-sw.js] 🔔 Showing browser notification');
  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click
self.addEventListener('notificationclick', (event) => {
  console.log('[firebase-messaging-sw.js] Notification clicked', event);
  
  event.notification.close();
  
  // Open app or focus existing window
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      // Check if there's already a window open
      for (const client of clientList) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          return client.focus();
        }
      }
      // If no window is open, open a new one
      if (clients.openWindow) {
        return clients.openWindow('/');
      }
    })
  );
});
