import { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { onAuthStateChanged } from 'firebase/auth';
import { auth } from '../services/firebase';
import { api } from '../services/api';
import { connectSocket, disconnectSocket } from '../services/socket';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [firebaseUser, setFirebaseUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (fbUser) => {
      setFirebaseUser(fbUser);

      if (fbUser) {
        const token = await fbUser.getIdToken();
        localStorage.setItem('token', token);

        try {
          const { user: profile } = await api.auth.login();
          setUser(profile);
          connectSocket(token);
        } catch (err) {
          console.error('Profile fetch error:', err);
        }
      } else {
        localStorage.removeItem('token');
        setUser(null);
        disconnectSocket();
      }

      setLoading(false);
    });

    return unsubscribe;
  }, []);

  const refreshToken = useCallback(async () => {
    if (auth.currentUser) {
      const token = await auth.currentUser.getIdToken(true);
      localStorage.setItem('token', token);
    }
  }, []);

  return (
    <AuthContext.Provider value={{ user, firebaseUser, loading, refreshToken, setUser }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
