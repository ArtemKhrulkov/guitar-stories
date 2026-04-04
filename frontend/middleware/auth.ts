export default defineNuxtRouteMiddleware(async (to) => {
  // List of public routes
  const publicRoutes = ['/login', '/register', '/verify', '/forgot-password', '/reset-password', '/admin/login'];
  
  if (publicRoutes.includes(to.path)) {
    return;
  }

  // Check auth status
  const { checkAuth } = useAuth();
  
  const user = await checkAuth();
  
  if (!user) {
    return navigateTo('/login');
  }
});