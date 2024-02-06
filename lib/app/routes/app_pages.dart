import 'package:get/get.dart';

import '../modules/booking_confirmation/bindings/booking_confirmation_binding.dart';
import '../modules/booking_confirmation/views/booking_confirmation_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/all_orders_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/location_permission/bindings/location_permission_binding.dart';
import '../modules/location_permission/views/location_permission_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/change_password_view.dart';
import '../modules/login/views/forgot_password_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/views/login_with_email_view.dart';
import '../modules/login/views/otp_verification_view.dart';
import '../modules/login/views/signup_view.dart';
import '../modules/my_earnings/bindings/my_earnings_binding.dart';
import '../modules/my_earnings/views/my_earnings_view.dart';
import '../modules/my_orders/bindings/my_orders_binding.dart';
import '../modules/my_orders/views/my_orders_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/ongoing_order/bindings/ongoing_order_binding.dart';
import '../modules/ongoing_order/views/ongoing_order_view.dart';
import '../modules/order_details/bindings/order_details_binding.dart';
import '../modules/order_details/views/order_details_view.dart';
import '../modules/pickup_parcel/bindings/pickup_parcel_binding.dart';
import '../modules/pickup_parcel/views/pickup_parcel_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/loggedin_change_password_view.dart';
import '../modules/profile/views/loggedin_change_password_view.dart';
import '../modules/profile/views/loggedin_verify_change_password_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_setup/bindings/profile_setup_binding.dart';
import '../modules/profile_setup/views/congratulations_view.dart';
import '../modules/profile_setup/views/driving_license_front_image_view.dart';
import '../modules/profile_setup/views/profile_setup_view.dart';
import '../modules/profile_setup/views/terms_and_conditions_view.dart';
import '../modules/profile_setup/views/vehicle_registration_view.dart';
import '../modules/reached_pickup_destination/bindings/reached_pickup_destination_binding.dart';
import '../modules/reached_pickup_destination/views/reached_pickup_destination_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ALL_ORDERS,
      page: () => AllOrdersView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_WITH_EMAIL,
      page: () => LoginWithEmailView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => OtpVerificationView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SETUP,
      page: () => const ProfileSetupView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: _Paths.DRIVING_LICENSE_FRONT_IMAGE,
      page: () => const DrivingLicenseFrontImageView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: _Paths.CONGRATULATIONS,
      page: () => const CongratulationsView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: _Paths.VEHICLE_REGISTRATION,
      page: () => VehicleRegistrationView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () => const TermsAndConditionsView(),
      binding: ProfileSetupBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.MY_ORDERS,
      page: () => const MyOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      name: _Paths.MY_EARNINGS,
      page: () => const MyEarningsView(),
      binding: MyEarningsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LOGGEDIN_CHANGE_PASSWORD,
      page: () => const LoggedinChangePasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LOGGEDIN_VERIFY_CHANGE_PASSWORD,
      page: () => LoggedinVerifyChangePasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_CONFIRMATION,
      page: () => const BookingConfirmationView(),
      binding: BookingConfirmationBinding(),
    ),
    GetPage(
      name: _Paths.PICKUP_PARCEL,
      page: () => PickupParcelView(),
      binding: PickupParcelBinding(),
    ),
    GetPage(
      name: _Paths.ONGOING_ORDER,
      page: () => OngoingOrderView(),
      binding: OngoingOrderBinding(),
    ),
    GetPage(
      name: _Paths.REACHED_PICKUP_DESTINATION,
      page: () => const ReachedPickupDestinationView(),
      binding: ReachedPickupDestinationBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS,
      page: () => const OrderDetailsView(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: _Paths.LOCATION_PERMISSION,
      page: () => const LocationPermissionView(),
      binding: LocationPermissionBinding(),
    ),
  ];
}
