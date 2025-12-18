# PWA Setup for FundEase

This document outlines the Progressive Web App (PWA) features that have been added to the FundEase application.

## Features Added

### 1. Service Worker
- Automatic caching of static assets
- Offline functionality with fallback page
- Background sync capabilities
- Automatic updates with user prompt

### 2. Web App Manifest
- App metadata (name, description, theme colors)
- Icon definitions for various sizes
- Display mode set to "standalone"
- Orientation locked to portrait

### 3. Install Prompt
- Custom install prompt component
- Automatic detection of install capability
- User-friendly installation flow

### 4. Offline Support
- Custom offline page (`/offline.html`)
- Cached API responses with NetworkFirst strategy
- Graceful degradation when offline

## Files Modified/Created

### Configuration Files
- `vite.config.js` - Added VitePWA plugin configuration
- `package.json` - Added PWA dependencies

### HTML & Meta Tags
- `index.html` - Added PWA meta tags and manifest link

### Vue Components
- `src/main.js` - Added service worker registration
- `src/App.vue` - Added PWA install prompt component
- `src/components/PWAInstallPrompt.vue` - Custom install prompt

### Static Assets
- `public/offline.html` - Offline fallback page
- `public/icon.svg` - Base icon for PWA
- `public/pwa-192x192.svg` - 192x192 PWA icon
- `public/pwa-512x512.svg` - 512x512 PWA icon
- `public/apple-touch-icon.svg` - Apple touch icon
- `public/masked-icon.svg` - Masked icon for Safari

## How to Use

### Development
```bash
npm run dev
```

### Production Build
```bash
npm run build
```

### Testing PWA Features
1. Build the application: `npm run build`
2. Serve the built files: `npm run preview`
3. Open in Chrome/Edge and check:
   - Install prompt appears
   - App can be installed
   - Offline functionality works
   - Service worker is registered

## PWA Checklist

- ✅ Web App Manifest
- ✅ Service Worker
- ✅ HTTPS (required for production)
- ✅ Responsive design
- ✅ Install prompt
- ✅ Offline functionality
- ✅ App icons (multiple sizes)
- ✅ Meta tags for mobile

## Browser Support

- Chrome/Edge: Full PWA support
- Firefox: Basic PWA support
- Safari: Limited PWA support (iOS 11.3+)
- Mobile browsers: Varies by platform

## Notes

- Icons are currently in SVG format. For production, convert to PNG using online tools or image processing libraries.
- The app will automatically update when new versions are deployed.
- Users will be prompted to refresh when updates are available.
- Offline page is shown when the app is accessed without internet connection.

## Future Enhancements

- Push notifications
- Background sync
- Advanced caching strategies
- App shortcuts
- Share target API


