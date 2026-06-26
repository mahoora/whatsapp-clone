export const login = async (req, res) => {
  res.json({
    user: req.user,
    token: req.headers.authorization?.split('Bearer ')[1],
  });
};

export const getProfile = async (req, res) => {
  res.json({ user: req.user });
};

export const updateProfile = async (req, res) => {
  const { displayName, about, photoURL } = req.body;
  if (displayName !== undefined) req.user.displayName = displayName;
  if (about !== undefined) req.user.about = about;
  if (photoURL !== undefined) req.user.photoURL = photoURL;
  await req.user.save();
  res.json({ user: req.user });
};
