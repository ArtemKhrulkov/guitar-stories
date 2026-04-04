export default defineNuxtRouteMiddleware(async (to) => {
  // Only protect admin routes
  if (!to.path.startsWith('/admin') || to.path === '/admin/login') {
    return;
  }

  const { checkAuth } = useAuth();

  const user = await checkAuth();

  if (!user) {
    return navigateTo('/admin/login');
  }

  // Check if user is admin (role is checked server-side too)
  if (user.role !== 'admin') {
    return navigateTo('/profile');
  }
});