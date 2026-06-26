const API_BASE = '/api';

const getToken = () => localStorage.getItem('token');

const request = async (endpoint, options = {}) => {
  const token = getToken();
  const res = await fetch(`${API_BASE}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || 'Request failed');
  return data;
};

export const api = {
  auth: {
    login: () => request('/auth/login', { method: 'POST' }),
    getProfile: () => request('/auth/profile'),
    updateProfile: (body) =>
      request('/auth/profile', { method: 'PUT', body: JSON.stringify(body) }),
  },
  users: {
    search: (query) => request(`/users/search?query=${encodeURIComponent(query)}`),
    getContacts: () => request('/users/contacts'),
    addContact: (phoneNumber) =>
      request('/users/contacts', {
        method: 'POST',
        body: JSON.stringify({ phoneNumber }),
      }),
  },
  chats: {
    getAll: () => request('/chats'),
    getOrCreate: (participantId) =>
      request('/chats', {
        method: 'POST',
        body: JSON.stringify({ participantId }),
      }),
    createGroup: (data) =>
      request('/chats/group', {
        method: 'POST',
        body: JSON.stringify(data),
      }),
  },
  messages: {
    get: (chatId, page = 1) => request(`/messages/${chatId}?page=${page}`),
    send: (data) =>
      request('/messages', {
        method: 'POST',
        body: JSON.stringify(data),
      }),
  },
};
