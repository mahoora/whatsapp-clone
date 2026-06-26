import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { searchUsers, getContacts, addContact } from '../controllers/userController.js';

const router = Router();

router.get('/search', authenticate, searchUsers);
router.get('/contacts', authenticate, getContacts);
router.post('/contacts', authenticate, addContact);

export default router;
