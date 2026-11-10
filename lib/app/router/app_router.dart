import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_session_provider.dart';
import '../../features/auth/presentation/screens/choose_role_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/dev/presentation/connection_test_screen.dart';
import '../../modules/auth/presentation/screens/buyer_signup_screen.dart';
import '../../modules/auth/presentation/screens/change_password_screen.dart';
import '../../modules/auth/presentation/screens/forgot_password_screen.dart';
import '../../modules/auth/presentation/screens/login_screen.dart';
import '../../modules/auth/presentation/screens/reset_password_screen.dart';
import '../../modules/auth/presentation/screens/seller_signup_screen.dart';
import '../../modules/chat/domain/chat_thread_model.dart';
import '../../modules/chat/presentation/screens/chat_conversation_screen.dart';
import '../../modules/chat/presentation/screens/chats_list_screen.dart';
import '../../modules/home/presentation/screens/home_screen.dart';
import '../../modules/marketplace/domain/listing_model.dart';
import '../../modules/marketplace/presentation/screens/listing_detail_screen.dart';
import '../../modules/marketplace/presentation/screens/post_ad_screen.dart';
import '../../modules/marketplace/presentation/screens/search_screen.dart';
import '../../modules/onboarding/presentation/screens/buyer_profile_screen.dart';
import '../../modules/onboarding/presentation/screens/seller_cnic_screen.dart';
import '../../modules/onboarding/presentation/screens/seller_dealership_screen.dart';
import '../../modules/profile/presentation/screens/edit_profile_screen.dart';
import '../../modules/profile/presentation/screens/profile_tab_screen.dart';
import '../../modules/profile/presentation/screens/saved_screen.dart';
import '../../modules/seller/presentation/screens/seller_my_ads_screen.dart';
import '../../modules/shell/presentation/screens/main_shell_screen.dart';
import '../../modules/splash/presentation/screens/splash_screen.dart';
import 'route_names.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AuthSessionProvider authProvider) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final auth = authProvider;
      final path = state.matchedLocation;

      const publicAuth = {
        RouteNames.splash,
        RouteNames.onboarding,
        RouteNames.chooseRole,
        RouteNames.login,
        RouteNames.buyerSignup,
        RouteNames.sellerSignup,
        RouteNames.forgotPassword,
        RouteNames.resetPassword,
        RouteNames.connectionTest,
      };

      const profileSetup = {
        RouteNames.buyerProfile,
        RouteNames.sellerDealership,
        RouteNames.sellerCnic,
      };

      const protected = {
        RouteNames.editProfile,
        RouteNames.savedListings,
        RouteNames.sellerMyAds,
        RouteNames.postAd,
        RouteNames.chatThread,
        RouteNames.changePassword,
      };

      if (!auth.isLoggedIn) {
        if (protected.contains(path)) return RouteNames.login;
        if (profileSetup.contains(path)) return RouteNames.login;
        return null;
      }

      if (auth.isLoadingProfile) return null;

      final setup = auth.postAuthRoute;
      if (setup != null && !profileSetup.contains(path) && path != RouteNames.splash) {
        if (path.startsWith('/app')) return setup;
        if (path == RouteNames.login || path == RouteNames.chooseRole) return setup;
      }

      if (auth.isLoggedIn && !auth.needsProfileSetup) {
        if (publicAuth.contains(path) && path != RouteNames.splash && path != RouteNames.connectionTest) {
          if (path == RouteNames.login || path == RouteNames.buyerSignup || path == RouteNames.sellerSignup) {
            return RouteNames.home;
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: RouteNames.connectionTest, builder: (_, __) => const ConnectionTestScreen()),
      GoRoute(path: RouteNames.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: RouteNames.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: RouteNames.chooseRole, builder: (_, __) => const ChooseRoleScreen()),
      GoRoute(path: RouteNames.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: RouteNames.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: RouteNames.resetPassword, builder: (_, __) => const ResetPasswordScreen()),
      GoRoute(
        path: RouteNames.changePassword,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const ChangePasswordScreen(),
      ),
      GoRoute(path: RouteNames.buyerSignup, builder: (_, __) => const BuyerSignupScreen()),
      GoRoute(path: RouteNames.sellerSignup, builder: (_, __) => const SellerSignupScreen()),
      GoRoute(
        path: RouteNames.otp,
        redirect: (_, __) => RouteNames.login,
      ),
      GoRoute(path: RouteNames.buyerProfile, builder: (_, __) => const BuyerProfileScreen()),
      GoRoute(path: RouteNames.sellerDealership, builder: (_, __) => const SellerDealershipScreen()),
      GoRoute(path: RouteNames.sellerCnic, builder: (_, __) => const SellerCnicScreen()),
      GoRoute(
        path: RouteNames.postAd,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const PostAdScreen(),
      ),
      GoRoute(
        path: RouteNames.listingDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final extra = state.extra;
          if (extra is String) return ListingDetailScreen(listingId: extra);
          if (extra is MachineryListing) return ListingDetailScreen(listing: extra);
          return const ListingDetailScreen(listingId: null);
        },
      ),
      GoRoute(
        path: RouteNames.chatThread,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final thread = state.extra as ChatThread? ?? ChatThread.demoThreads.first;
          return ChatConversationScreen(thread: thread);
        },
      ),
      GoRoute(
        path: RouteNames.savedListings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const SavedScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.sellerMyAds,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const SellerMyAdsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/app/home', builder: (_, __) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/app/search', builder: (_, __) => const SearchScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/app/chats', builder: (_, __) => const ChatsListScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/app/profile', builder: (_, __) => const ProfileTabScreen())]),
        ],
      ),
    ],
  );
}
