// firebaseConfig.ts
import { initializeApp, getApps } from "firebase/app";
import { getDatabase, Database, ref as refi } from "firebase/database";
import firebase from 'firebase/compat/app';
import 'firebase/compat/auth';


const firebaseConfig = {
    apiKey: "AIzaSyDAXkrNBCIGcRVLAeLITmyntFKZpji5qTI",
    authDomain: "proyectotransporte-fcee0.firebaseapp.com",
    projectId: "proyectotransporte-fcee0",
    storageBucket: "proyectotransporte-fcee0.appspot.com",
    messagingSenderId: "1093899469615",
    appId: "1:1093899469615:web:4c593e2af3cd65689117da",
    measurementId: "G-PGYCJE0FSR"
};

let app;
if (!getApps().length) {
    app = initializeApp(firebaseConfig);
} else {
    app = getApps()[0];
}
if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig);
  }
  
  const auth = firebase.auth();
  export { auth };

const database: Database = getDatabase(app);
export { database, refi };
