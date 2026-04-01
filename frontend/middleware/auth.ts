export default defineNuxtRouteMiddleware(async (to) => {
  if (!to.path.startsWith('/admin') || to.path === '/admin/login') {
    return;
  }

  const { checkAuth } = useAdminAuth();

  const authenticated = await checkAuth();

  if (!authenticated) {
    return navigateTo('/admin/login');
  }
});
