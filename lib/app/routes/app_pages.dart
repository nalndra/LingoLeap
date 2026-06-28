import 'package:get/get.dart';

import '../modules/ChatLippo/bindings/chat_lippo_binding.dart';
import '../modules/ChatLippo/views/chat_lippo_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/latihan/bindings/latihan_binding.dart';
import '../modules/latihan/views/latihan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/new_password/bindings/new_password_binding.dart';
import '../modules/new_password/views/new_password_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/progress/bindings/progress_binding.dart';
import '../modules/progress/views/progress_view.dart';
import '../modules/quest/bindings/quest_binding.dart';
import '../modules/quest/views/quest_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/tutorial/bindings/tutorial_binding.dart';
import '../modules/tutorial/views/tutorial_view.dart';
import '../modules/verify_email/bindings/verify_email_binding.dart';
import '../modules/verify_email/views/verify_email_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';

import '../modules/parent_login/bindings/parent_login_binding.dart';
import '../modules/parent_login/views/parent_login_view.dart';
import '../modules/parent_register/bindings/parent_register_binding.dart';
import '../modules/parent_register/views/parent_register_view.dart';
import '../modules/parent_dashboard/bindings/parent_dashboard_binding.dart';
import '../modules/parent_dashboard/views/parent_dashboard_view.dart';
import '../modules/parent_settings/bindings/parent_settings_binding.dart';
import '../modules/parent_settings/views/parent_settings_view.dart';
import '../modules/premium/bindings/premium_binding.dart';
import '../modules/premium/views/premium_view.dart';
import '../modules/pin/bindings/pin_binding.dart';
import '../modules/pin/views/pin_setup_view.dart';
import '../modules/pin/views/pin_confirm_view.dart';
import '../modules/pin/views/pin_login_view.dart';
import '../modules/add_child/bindings/add_child_binding.dart';
import '../modules/add_child/views/add_child_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => const NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL,
      page: () => const TutorialView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.LATIHAN,
      page: () => const LatihanView(),
      binding: LatihanBinding(),
    ),
    GetPage(
      name: _Paths.PROGRESS,
      page: () => const ProgressView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.QUEST,
      page: () => const QuestView(),
      binding: QuestBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.CHAT_LIPPO,
      page: () => const ChatLippoView(),
      binding: ChatLippoBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_EMAIL,
      page: () => const VerifyEmailView(),
      binding: VerifyEmailBinding(),
    ),
    GetPage(
      name: _Paths.PARENT_LOGIN,
      page: () => const ParentLoginView(),
      binding: ParentLoginBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.PARENT_REGISTER,
      page: () => const ParentRegisterView(),
      binding: ParentRegisterBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.PARENT_DASHBOARD,
      page: () => const ParentDashboardView(),
      binding: ParentDashboardBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.PARENT_SETTINGS,
      page: () => const ParentSettingsView(),
      binding: ParentSettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.PREMIUM,
      page: () => const PremiumView(),
      binding: PremiumBinding(),
    ),
    GetPage(
      name: _Paths.PIN_SETUP,
      page: () => const PinSetupView(),
      binding: PinBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.PIN_CONFIRM,
      page: () => const PinConfirmView(),
      binding: PinBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.PIN_LOGIN,
      page: () => const PinLoginView(),
      binding: PinBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ADD_CHILD,
      page: () => const AddChildView(),
      binding: AddChildBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
