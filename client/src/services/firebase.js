import { initializeApp } from 'firebase/app';
import {
  getAuth,
  RecaptchaVerifier,
  signInWithPhoneNumber,
} from 'firebase/auth';

const firebaseConfig = {
  apiKey: 'AIzaSyCxgbprb8mvHuWxtW7kev26SXfVabtm_Ag',
  authDomain: 'studio-1264128917-7f1a5.firebaseapp.com',
  projectId: 'studio-1264128917-7f1a5',
  storageBucket: 'studio-1264128917-7f1a5.firebasestorage.app',
  messagingSenderId: '517846157163',
  appId: '1:517846157163:web:daa26ae9bde5549fa8ae2e',
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
auth.useDeviceLanguage();

export const setupRecaptcha = (containerId) => {
  if (window.recaptchaVerifier) {
    window.recaptchaVerifier.clear();
  }
  window.recaptchaVerifier = new RecaptchaVerifier(auth, containerId, {
    size: 'invisible',
    callback: () => {},
  });
  return window.recaptchaVerifier;
};

export const sendOTP = async (phoneNumber, containerId = 'recaptcha-container') => {
  const recaptchaVerifier = setupRecaptcha(containerId);
  const confirmationResult = await signInWithPhoneNumber(
    auth,
    phoneNumber,
    recaptchaVerifier
  );
  return confirmationResult;
};

export const verifyOTP = async (confirmationResult, otp) => {
  const result = await confirmationResult.confirm(otp);
  if (window.recaptchaVerifier) {
    window.recaptchaVerifier.clear();
    window.recaptchaVerifier = null;
  }
  return result.user;
};
