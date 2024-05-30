import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries
// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDAXkrNBCIGcRVLAeLITmyntFKZpji5qTI",
  authDomain: "proyectotransporte-fcee0.firebaseapp.com",
  projectId: "proyectotransporte-fcee0",
  storageBucket: "proyectotransporte-fcee0.appspot.com",
  messagingSenderId: "1093899469615",
  appId: "1:1093899469615:web:4c593e2af3cd65689117da",
  measurementId: "G-PGYCJE0FSR"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

const container = document.getElementById('root');
const root = createRoot(container!);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);