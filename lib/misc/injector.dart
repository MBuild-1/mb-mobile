import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../controller/chathistorycontroller/chathistorysubpagecontroller/help_chat_history_sub_controller.dart';
import '../controller/chathistorycontroller/chathistorysubpagecontroller/order_chat_history_sub_controller.dart';
import '../controller/chathistorycontroller/chathistorysubpagecontroller/product_chat_history_sub_controller.dart';
import '../controller/deliveryreviewcontroller/deliveryreviewsubpagecontroller/history_delivery_review_sub_controller.dart';
import '../controller/deliveryreviewcontroller/deliveryreviewsubpagecontroller/waiting_to_be_reviewed_delivery_review_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/explore_nusantara_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/feed_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/home_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/mbestie_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/menu_main_menu_sub_controller.dart';
import '../controller/mainmenucontroller/mainmenusubpagecontroller/wishlist_main_menu_sub_controller.dart';
import '../data/datasource/addressdatasource/address_data_source.dart';
import '../data/datasource/addressdatasource/default_address_data_source.dart';
import '../data/datasource/bannerdatasource/banner_data_source.dart';
import '../data/datasource/bannerdatasource/default_banner_data_source.dart';
import '../data/datasource/bucketdatasource/bucket_data_source.dart';
import '../data/datasource/bucketdatasource/default_bucket_data_source.dart';
import '../data/datasource/cargodatasource/cargo_data_source.dart';
import '../data/datasource/cargodatasource/default_cargo_data_source.dart';
import '../data/datasource/cartdatasource/cart_data_source.dart';
import '../data/datasource/cartdatasource/default_cart_data_source.dart';
import '../data/datasource/chatdatasource/chat_data_source.dart';
import '../data/datasource/chatdatasource/default_chat_data_source.dart';
import '../data/datasource/coupondatasource/coupon_data_source.dart';
import '../data/datasource/coupondatasource/default_coupon_data_source.dart';
import '../data/datasource/faqdatasource/default_faq_data_source.dart';
import '../data/datasource/faqdatasource/faq_data_source.dart';
import '../data/datasource/feeddatasource/default_feed_data_source.dart';
import '../data/datasource/feeddatasource/feed_data_source.dart';
import '../data/datasource/mapdatasource/default_map_data_source.dart';
import '../data/datasource/mapdatasource/map_data_source.dart';
import '../data/datasource/notificationdatasource/default_notification_data_source.dart';
import '../data/datasource/notificationdatasource/notification_data_source.dart';
import '../data/datasource/orderdatasource/default_order_data_source.dart';
import '../data/datasource/orderdatasource/order_data_source.dart';
import '../data/datasource/paymentdatasource/default_payment_data_source.dart';
import '../data/datasource/paymentdatasource/payment_data_source.dart';
import '../data/datasource/productdatasource/default_product_data_source.dart';
import '../data/datasource/productdatasource/product_data_source.dart';
import '../data/datasource/productdiscussiondatasource/default_product_discussion_data_source.dart';
import '../data/datasource/productdiscussiondatasource/product_discussion_data_source.dart';
import '../data/datasource/searchdatasource/default_search_data_source.dart';
import '../data/datasource/searchdatasource/search_data_source.dart';
import '../data/datasource/userdatasource/default_user_data_source.dart';
import '../data/datasource/userdatasource/user_data_source.dart';
import '../data/datasource/versioningdatasource/default_versioning_data_source.dart';
import '../data/datasource/versioningdatasource/versioning_data_source.dart';
import '../data/repository/default_address_repository.dart';
import '../data/repository/default_banner_repository.dart';
import '../data/repository/default_bucket_repository.dart';
import '../data/repository/default_cargo_repository.dart';
import '../data/repository/default_cart_repository.dart';
import '../data/repository/default_chat_repository.dart';
import '../data/repository/default_coupon_repository.dart';
import '../data/repository/default_faq_repository.dart';
import '../data/repository/default_feed_repository.dart';
import '../data/repository/default_map_repository.dart';
import '../data/repository/default_notification_repository.dart';
import '../data/repository/default_order_repository.dart';
import '../data/repository/default_payment_repository.dart';
import '../data/repository/default_product_discussion_repository.dart';
import '../data/repository/default_product_repository.dart';
import '../data/repository/default_search_repository.dart';
import '../data/repository/default_user_repository.dart';
import '../data/repository/default_versioning_repository.dart';
import '../domain/dummy/addressdummy/address_dummy.dart';
import '../domain/dummy/addressdummy/address_user_dummy.dart';
import '../domain/dummy/addressdummy/country_dummy.dart';
import '../domain/dummy/addressdummy/zone_dummy.dart';
import '../domain/dummy/cartdummy/cart_dummy.dart';
import '../domain/dummy/coupondummy/coupon_dummy.dart';
import '../domain/dummy/deliveryreviewdummy/delivery_review_dummy.dart';
import '../domain/dummy/newsdummy/news_dummy.dart';
import '../domain/dummy/productdummy/product_brand_dummy.dart';
import '../domain/dummy/productdummy/product_bundle_dummy.dart';
import '../domain/dummy/productdummy/product_category_dummy.dart';
import '../domain/dummy/productdummy/product_certification_dummy.dart';
import '../domain/dummy/productdummy/product_dummy.dart';
import '../domain/dummy/productdummy/product_entry_dummy.dart';
import '../domain/dummy/productdummy/product_variant_dummy.dart';
import '../domain/dummy/provincedummy/province_dummy.dart';
import '../domain/dummy/userdummy/user_dummy.dart';
import '../domain/repository/address_repository.dart';
import '../domain/repository/banner_repository.dart';
import '../domain/repository/bucket_repository.dart';
import '../domain/repository/cargo_repository.dart';
import '../domain/repository/cart_repository.dart';
import '../domain/repository/chat_repository.dart';
import '../domain/repository/coupon_repository.dart';
import '../domain/repository/faq_repository.dart';
import '../domain/repository/feed_repository.dart';
import '../domain/repository/map_repository.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/repository/order_repository.dart';
import '../domain/repository/payment_repository.dart';
import '../domain/repository/product_discussion_repository.dart';
import '../domain/repository/product_repository.dart';
import '../domain/repository/search_repository.dart';
import '../domain/repository/user_repository.dart';
import '../domain/repository/versioning_repository.dart';
import '../domain/usecase/add_additional_item_use_case.dart';
import '../domain/usecase/add_address_use_case.dart';
import '../domain/usecase/add_host_cart_use_case.dart';
import '../domain/usecase/add_to_cart_use_case.dart';
import '../domain/usecase/add_to_favorite_product_brand_use_case.dart';
import '../domain/usecase/add_warehouse_in_order_use_case.dart';
import '../domain/usecase/add_wishlist_use_case.dart';
import '../domain/usecase/answer_help_conversation_use_case.dart';
import '../domain/usecase/answer_help_conversation_version_1_point_1_use_case.dart';
import '../domain/usecase/answer_order_conversation_use_case.dart';
import '../domain/usecase/answer_order_conversation_version_1_point_1_use_case.dart';
import '../domain/usecase/answer_product_conversation_use_case.dart';
import '../domain/usecase/approve_or_reject_request_bucket_use_case.dart';
import '../domain/usecase/arrived_order_use_case.dart';
import '../domain/usecase/auth_identity_change_input_use_case.dart';
import '../domain/usecase/auth_identity_change_use_case.dart';
import '../domain/usecase/auth_identity_change_verify_otp_use_case.dart';
import '../domain/usecase/auth_identity_send_verify_otp_use_case.dart';
import '../domain/usecase/auth_identity_use_case.dart';
import '../domain/usecase/auth_identity_verify_otp_use_case.dart';
import '../domain/usecase/all_versioning_use_case.dart';
import '../domain/usecase/change_additional_item_use_case.dart';
import '../domain/usecase/change_address_use_case.dart';
import '../domain/usecase/change_password_use_case.dart';
import '../domain/usecase/check_reset_password_use_case.dart';
import '../domain/usecase/checkout_bucket_version_1_point_1_use_case.dart';
import '../domain/usecase/create_order_version_1_point_1_use_case.dart';
import '../domain/usecase/get_country_based_country_code.dart';
import '../domain/usecase/get_product_bundle_detail_by_slug_use_case.dart';
import '../domain/usecase/get_product_detail_by_slug_use_case.dart';
import '../domain/usecase/get_user_and_loaded_related_user_data_use_case.dart';
import '../domain/usecase/help_chat_template_use_case.dart';
import '../domain/usecase/check_active_pin_use_case.dart';
import '../domain/usecase/check_bucket_use_case.dart';
import '../domain/usecase/check_coupon_use_case.dart';
import '../domain/usecase/check_rates_for_various_countries_use_case.dart';
import '../domain/usecase/checkout_bucket_use_case.dart';
import '../domain/usecase/create_bucket_use_case.dart';
import '../domain/usecase/create_help_conversation_use_case.dart';
import '../domain/usecase/create_order_conversation_use_case.dart';
import '../domain/usecase/create_order_use_case.dart';
import '../domain/usecase/create_product_conversation_use_case.dart';
import '../domain/usecase/create_product_discussion_use_case.dart';
import '../domain/usecase/destroy_bucket_use_case.dart';
import '../domain/usecase/edit_user_use_case.dart';
import '../domain/usecase/forgot_password_use_case.dart';
import '../domain/usecase/get_additional_item_use_case.dart';
import '../domain/usecase/get_address_based_id_use_case.dart';
import '../domain/usecase/get_address_list_use_case.dart';
import '../domain/usecase/get_address_paging_use_case.dart';
import '../domain/usecase/get_beauty_product_indonesia_list_use_case.dart';
import '../domain/usecase/get_bestseller_in_masterbagasi_list_use_case.dart';
import '../domain/usecase/get_cart_list_ignoring_login_error_use_case.dart';
import '../domain/usecase/get_cart_list_use_case.dart';
import '../domain/usecase/get_cart_summary_use_case.dart';
import '../domain/usecase/get_check_your_contribution_delivery_review_detail_use_case.dart';
import '../domain/usecase/get_coffee_and_tea_origin_indonesia_list_use_case.dart';
import '../domain/usecase/get_country_delivery_review_use_case.dart';
import '../domain/usecase/get_country_list_use_case.dart';
import '../domain/usecase/get_country_paging_use_case.dart';
import '../domain/usecase/get_coupon_detail_use_case.dart';
import '../domain/usecase/get_coupon_list_use_case.dart';
import '../domain/usecase/get_coupon_paging_use_case.dart';
import '../domain/usecase/get_coupon_tac_list_use_case.dart';
import '../domain/usecase/get_current_selected_address_use_case.dart';
import '../domain/usecase/get_delivery_review_use_case.dart';
import '../domain/usecase/get_faq_list_use_case.dart';
import '../domain/usecase/get_fashion_product_indonesia_list_use_case.dart';
import '../domain/usecase/get_favorite_product_brand_list_use_case.dart';
import '../domain/usecase/get_favorite_product_brand_use_case.dart';
import '../domain/usecase/get_handycrafts_contents_banner_use_case.dart';
import '../domain/usecase/get_help_message_by_conversation_use_case.dart';
import '../domain/usecase/get_help_message_by_user_use_case.dart';
import '../domain/usecase/get_help_message_notification_count_use_case.dart';
import '../domain/usecase/get_history_delivery_review_list_use_case.dart';
import '../domain/usecase/get_homepage_contents_banner_use_case.dart';
import '../domain/usecase/get_kitchen_contents_banner_use_case.dart';
import '../domain/usecase/get_my_cart_use_case.dart';
import '../domain/usecase/get_news_detail_use_case.dart';
import '../domain/usecase/get_news_paging_use_case.dart';
import '../domain/usecase/get_news_use_case.dart';
import '../domain/usecase/get_notification_by_user_list_use_case.dart';
import '../domain/usecase/get_notification_by_user_paging_use_case.dart';
import '../domain/usecase/get_only_for_you_list_use_case.dart';
import '../domain/usecase/get_order_based_id_use_case.dart';
import '../domain/usecase/get_order_message_by_combined_order_use_case.dart';
import '../domain/usecase/get_order_message_by_conversation_use_case.dart';
import '../domain/usecase/get_order_message_by_user_use_case.dart';
import '../domain/usecase/get_order_paging_use_case.dart';
import '../domain/usecase/get_product_brand_paging_use_case.dart';
import '../domain/usecase/get_product_brand_use_case.dart';
import '../domain/usecase/get_product_bundle_detail_use_case.dart';
import '../domain/usecase/get_product_bundle_highlight_use_case.dart';
import '../domain/usecase/get_product_bundle_list_use_case.dart';
import '../domain/usecase/get_product_bundle_paging_use_case.dart';
import '../domain/usecase/get_product_category_detail_use_case.dart';
import '../domain/usecase/get_product_category_list_use_case.dart';
import '../domain/usecase/get_product_category_paging_use_case.dart';
import '../domain/usecase/get_product_detail_from_your_search_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_chosen_for_you_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_from_this_brand_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_in_this_category_product_entry_list_use_case.dart';
import '../domain/usecase/get_product_detail_other_interested_product_brand_list_use_case.dart';
import '../domain/usecase/get_product_detail_use_case.dart';
import '../domain/usecase/get_product_discussion_based_user_use_case.dart';
import '../domain/usecase/get_product_discussion_use_case.dart';
import '../domain/usecase/get_product_entry_header_content_use_case.dart';
import '../domain/usecase/get_product_entry_with_condition_paging_use_case.dart';
import '../domain/usecase/get_product_list_use_case.dart';
import '../domain/usecase/get_product_message_by_conversation_use_case.dart';
import '../domain/usecase/get_product_message_by_product_use_case.dart';
import '../domain/usecase/get_product_message_by_user_use_case.dart';
import '../domain/usecase/get_product_viral_list_use_case.dart';
import '../domain/usecase/get_product_viral_paging_use_case.dart';
import '../domain/usecase/get_province_map_use_case.dart';
import '../domain/usecase/get_ready_to_eat_street_food_style_list_use_case.dart';
import '../domain/usecase/get_selected_beauty_brands_list_use_case.dart';
import '../domain/usecase/get_selected_beauty_brands_paging_use_case.dart';
import '../domain/usecase/get_selected_fashion_brands_list_use_case.dart';
import '../domain/usecase/get_selected_fashion_brands_paging_use_case.dart';
import '../domain/usecase/get_shared_cart_summary_use_case.dart';
import '../domain/usecase/get_shipping_price_contents_banner_use_case.dart';
import '../domain/usecase/get_shipping_review_order_list_use_case.dart';
import '../domain/usecase/get_short_my_cart_use_case.dart';
import '../domain/usecase/get_short_video_paging_use_case.dart';
import '../domain/usecase/get_short_video_use_case.dart';
import '../domain/usecase/get_snack_for_lying_around_list_use_case.dart';
import '../domain/usecase/get_sponsor_contents_banner_use_case.dart';
import '../domain/usecase/get_support_discussion_use_case.dart';
import '../domain/usecase/get_transaction_notification_detail_use_case.dart';
import '../domain/usecase/get_trip_default_video_paging_use_case.dart';
import '../domain/usecase/get_trip_default_video_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/get_waiting_to_be_reviewed_delivery_review_paging_use_case.dart';
import '../domain/usecase/get_wishlist_list_ignoring_login_error.dart';
import '../domain/usecase/get_wishlist_list_use_case.dart';
import '../domain/usecase/get_wishlist_paging_use_case.dart';
import '../domain/usecase/give_review_delivery_review_detail_use_case.dart';
import '../domain/usecase/leave_bucket_use_case.dart';
import '../domain/usecase/login_or_register_with_apple_via_callback_use_case.dart';
import '../domain/usecase/login_use_case.dart';
import '../domain/usecase/login_with_apple_use_case.dart';
import '../domain/usecase/login_with_google_use_case.dart';
import '../domain/usecase/logout_use_case.dart';
import '../domain/usecase/modify_pin_use_case.dart';
import '../domain/usecase/notification_order_status_use_case.dart';
import '../domain/usecase/order_transaction_use_case.dart';
import '../domain/usecase/payment_instruction_use_case.dart';
import '../domain/usecase/payment_method_list_use_case.dart';
import '../domain/usecase/purchase_direct_use_case.dart';
import '../domain/usecase/read_all_notification_use_case.dart';
import '../domain/usecase/read_transaction_notification_use_case.dart';
import '../domain/usecase/register_first_step_use_case.dart';
import '../domain/usecase/register_second_step_use_case.dart';
import '../domain/usecase/register_use_case.dart';
import '../domain/usecase/register_with_apple_use_case.dart';
import '../domain/usecase/register_with_google_use_case.dart';
import '../domain/usecase/remove_additional_item_use_case.dart';
import '../domain/usecase/remove_address_use_case.dart';
import '../domain/usecase/remove_all_search_history_use_case.dart';
import '../domain/usecase/remove_from_cart_directly_use_case.dart';
import '../domain/usecase/remove_from_cart_use_case.dart';
import '../domain/usecase/remove_from_favorite_product_brand_use_case.dart';
import '../domain/usecase/remove_member_bucket_use_case.dart';
import '../domain/usecase/remove_wishlist_based_product_use_case.dart';
import '../domain/usecase/remove_wishlist_use_case.dart';
import '../domain/usecase/reply_product_discussion_use_case.dart';
import '../domain/usecase/repurchase_use_case.dart';
import '../domain/usecase/request_join_bucket_use_case.dart';
import '../domain/usecase/reset_password_use_case.dart';
import '../domain/usecase/search_history_use_case.dart';
import '../domain/usecase/search_last_seen_history_use_case.dart';
import '../domain/usecase/search_use_case.dart';
import '../domain/usecase/send_delete_account_otp_use_case.dart';
import '../domain/usecase/send_register_otp_use_case.dart';
import '../domain/usecase/share_product_use_case.dart';
import '../domain/usecase/shipper_address_use_case.dart';
import '../domain/usecase/shipping_payment_use_case.dart';
import '../domain/usecase/show_bucket_by_id_use_case.dart';
import '../domain/usecase/store_keyword_for_search_history_use_case.dart';
import '../domain/usecase/store_search_last_seen_history_use_case.dart';
import '../domain/usecase/take_friend_cart_use_case.dart';
import '../domain/usecase/third_party_login_visibility_use_case.dart';
import '../domain/usecase/trigger_bucket_ready_use_case.dart';
import '../domain/usecase/update_cart_quantity_use_case.dart';
import '../domain/usecase/update_current_selected_address_use_case.dart';
import '../domain/usecase/update_read_status_help_conversation_use_case.dart';
import '../domain/usecase/update_read_status_order_conversation_use_case.dart';
import '../domain/usecase/update_read_status_product_conversation_use_case.dart';
import '../domain/usecase/verify_delete_account_otp_use_case.dart';
import '../domain/usecase/verify_register_use_case.dart';
import '../domain/usecase/versioning_based_filter_use_case.dart';
import '../domain/usecase/whatsapp_forgot_password_use_case.dart';
import 'additionalloadingindicatorchecker/cart_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/coupon_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/feed_sub_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/home_sub_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/host_cart_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/menu_main_menu_sub_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_brand_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_bundle_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_bundle_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_category_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/product_detail_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/shared_cart_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/take_friend_cart_additional_paging_result_parameter_checker.dart';
import 'additionalloadingindicatorchecker/wishlist_sub_additional_paging_result_parameter_checker.dart';
import 'controllercontentdelegate/arrived_order_controller_content_delegate.dart';
import 'controllercontentdelegate/product_brand_favorite_controller_content_delegate.dart';
import 'controllercontentdelegate/repurchase_controller_content_delegate.dart';
import 'controllercontentdelegate/shared_cart_controller_content_delegate.dart';
import 'controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import 'defaultloaddataresultwidget/default_load_data_result_widget.dart';
import 'defaultloaddataresultwidget/main_default_load_data_result_widget.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_entity_and_list_item_controller_state_mediator.dart';
import 'errorprovider/default_error_provider.dart';
import 'errorprovider/error_provider.dart';
import 'http_client.dart';
import 'on_observe_load_product_delegate.dart';
import 'shimmercarousellistitemgenerator/factory/cart_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/coupon_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/delivery_review_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/news_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_brand_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_category_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';

class _Injector {
  final GetIt locator = GetIt.instance;

  void init() {
    // Controller Injection Factory
    locator.registerLazySingleton<HomeMainMenuSubControllerInjectionFactory>(
      () => HomeMainMenuSubControllerInjectionFactory(
        getProductEntryWithConditionPagingUseCase: locator(),
        getProductViralListUseCase: locator(),
        getProductCategoryListUseCase: locator(),
        getProductBrandListUseCase: locator(),
        getProductBundleListUseCase: locator(),
        getProductBundleHighlightUseCase: locator(),
        getProductBundlePagingUseCase: locator(),
        getSnackForLyingAroundListUseCase: locator(),
        getBestsellerInMasterbagasiListUseCase: locator(),
        getSelectedFashionBrandsListUseCase: locator(),
        getSelectedBeautyBrandsListUseCase: locator(),
        getCoffeeAndTeaOriginIndonesiaListUseCase: locator(),
        getBeautyProductIndonesiaListUseCase: locator(),
        getFashionProductIndonesiaListUseCase: locator(),
        getReadyToEatStreetFoodStyleListUseCase: locator(),
        getOnlyForYouListUseCase: locator(),
        getHandycraftsContentsBannerUseCase: locator(),
        getKitchenContentsBannerUseCase: locator(),
        getSponsorContentsBannerUseCase: locator(),
        addWishlistUseCase: locator(),
        getCurrentSelectedAddressUseCase: locator(),
        getHomepageContentsBannerUseCase: locator(),
        getShippingPriceContentsBannerUseCase: locator(),
        wishlistAndCartControllerContentDelegate: locator()
      )
    );
    locator.registerLazySingleton<FeedMainMenuSubControllerInjectionFactory>(
      () => FeedMainMenuSubControllerInjectionFactory(
        getShortVideoUseCase: locator(),
        getDeliveryReviewUseCase: locator(),
        getNewsUseCase: locator(),
        getTripDefaultVideoUseCase: locator()
      )
    );
    locator.registerLazySingleton<ExploreNusantaraMainMenuSubControllerInjectionFactory>(
      () => ExploreNusantaraMainMenuSubControllerInjectionFactory(
        getProvinceMapUseCase: locator()
      )
    );
    locator.registerLazySingleton<MBestieMainMenuSubControllerInjectionFactory>(
      () => MBestieMainMenuSubControllerInjectionFactory()
    );
    locator.registerLazySingleton<WishlistMainMenuSubControllerInjectionFactory>(
      () => WishlistMainMenuSubControllerInjectionFactory(
        getWishlistPagingUseCase: locator(),
        getWishlistListUseCase: locator(),
        addToCartUseCase: locator(),
        removeWishlistUseCase: locator(),
        wishlistAndCartControllerContentDelegate: locator()
      )
    );
    locator.registerLazySingleton<MenuMainMenuSubControllerInjectionFactory>(
      () => MenuMainMenuSubControllerInjectionFactory(
        getUserUseCase: locator(),
        getUserAndLoadedRelatedUserDataUseCase: locator(),
        getShortMyCartUseCase: locator(),
        logoutUseCase: locator(),
        sharedCartControllerContentDelegate: locator()
      )
    );
    locator.registerLazySingleton<WaitingToBeReviewedDeliveryReviewSubControllerInjectionFactory>(
      () => WaitingToBeReviewedDeliveryReviewSubControllerInjectionFactory(
        getWaitingToBeReviewedDeliveryReviewPagingUseCase: locator(),
        getUserUseCase: locator(),
        getShippingReviewOrderListUseCase: locator(),
      )
    );
    locator.registerLazySingleton<HistoryDeliveryReviewSubControllerInjectionFactory>(
      () => HistoryDeliveryReviewSubControllerInjectionFactory(
        getHistoryDeliveryReviewListUseCase: locator()
      )
    );
    locator.registerLazySingleton<HelpChatHistorySubControllerInjectionFactory>(
      () => HelpChatHistorySubControllerInjectionFactory()
    );
    locator.registerLazySingleton<ProductChatHistorySubControllerInjectionFactory>(
      () => ProductChatHistorySubControllerInjectionFactory(
        getProductMessageByUserUseCase: locator()
      )
    );
    locator.registerLazySingleton<OrderChatHistorySubControllerInjectionFactory>(
      () => OrderChatHistorySubControllerInjectionFactory(
        getOrderMessageByUserUseCase: locator()
      )
    );

    // Error Provider
    locator.registerLazySingleton<ErrorProvider>(() => DefaultErrorProvider());

    // Entity And List Item Controller State Mediator
    locator.registerLazySingleton<HorizontalParameterizedEntityAndListItemControllerStateMediator>(() => HorizontalParameterizedEntityAndListItemControllerStateMediator());
    locator.registerLazySingleton<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>(
      () => HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator(
        horizontalEntityAndListItemControllerStateMediator: locator(),
        errorProvider: locator()
      )
    );

    // On Observe Load Product Delegate Factory
    locator.registerFactory<OnObserveLoadProductDelegateFactory>(
      () => OnObserveLoadProductDelegateFactory()
    );

    // Dummy
    locator.registerLazySingleton<ProductDummy>(
      () => ProductDummy(
        productBrandDummy: locator(),
        productCategoryDummy: locator(),
        productCertificationDummy: locator(),
        provinceDummy: locator(),
      )
    );
    locator.registerLazySingleton<ProductEntryDummy>(() => ProductEntryDummy(productDummy: locator()));
    locator.registerLazySingleton<ProvinceDummy>(() => ProvinceDummy());
    locator.registerLazySingleton<ProductBrandDummy>(() => ProductBrandDummy());
    locator.registerLazySingleton<ProductCategoryDummy>(() => ProductCategoryDummy());
    locator.registerLazySingleton<ProductCertificationDummy>(() => ProductCertificationDummy());
    locator.registerLazySingleton<ProductVariantDummy>(() => ProductVariantDummy());
    locator.registerLazySingleton<ProductBundleDummy>(() => ProductBundleDummy());
    locator.registerLazySingleton<DeliveryReviewDummy>(() => DeliveryReviewDummy());
    locator.registerLazySingleton<NewsDummy>(() => NewsDummy());
    locator.registerLazySingleton<CouponDummy>(() => CouponDummy());
    locator.registerLazySingleton<CartDummy>(() => CartDummy(productEntryDummy: locator()));
    locator.registerLazySingleton<AddressDummy>(
      () => AddressDummy(
        countryDummy: locator(),
        addressUserDummy: locator(),
      )
    );
    locator.registerLazySingleton<AddressUserDummy>(() => AddressUserDummy());
    locator.registerLazySingleton<CountryDummy>(() => CountryDummy(zoneDummy: locator()));
    locator.registerLazySingleton<ZoneDummy>(() => ZoneDummy());
    locator.registerLazySingleton<UserDummy>(() => UserDummy());

    // Shimmer Carousel List Item Generator
    locator.registerFactory<ProductShimmerCarouselListItemGeneratorFactory>(
      () => ProductShimmerCarouselListItemGeneratorFactory(
        productDummy: locator(),
        productEntryDummy: locator()
      )
    );
    locator.registerFactory<ProductCategoryShimmerCarouselListItemGeneratorFactory>(
      () => ProductCategoryShimmerCarouselListItemGeneratorFactory(
        productCategoryDummy: locator()
      )
    );
    locator.registerFactory<ProductBundleShimmerCarouselListItemGeneratorFactory>(
      () => ProductBundleShimmerCarouselListItemGeneratorFactory(
        productBundleDummy: locator()
      )
    );
    locator.registerFactory<ProductBrandShimmerCarouselListItemGeneratorFactory>(
      () => ProductBrandShimmerCarouselListItemGeneratorFactory(
        productBrandDummy: locator()
      )
    );
    locator.registerFactory<DeliveryReviewShimmerCarouselListItemGeneratorFactory>(
      () => DeliveryReviewShimmerCarouselListItemGeneratorFactory(
        deliveryReviewDummy: locator()
      )
    );
    locator.registerFactory<NewsShimmerCarouselListItemGeneratorFactory>(
      () => NewsShimmerCarouselListItemGeneratorFactory(
        newsDummy: locator()
      )
    );
    locator.registerFactory<CouponShimmerCarouselListItemGeneratorFactory>(
      () => CouponShimmerCarouselListItemGeneratorFactory(
        couponDummy: locator()
      )
    );
    locator.registerFactory<CartShimmerCarouselListItemGeneratorFactory>(
      () => CartShimmerCarouselListItemGeneratorFactory(
        cartDummy: locator()
      )
    );

    // Additional Paging Result Parameter
    locator.registerFactory<HomeSubAdditionalPagingResultParameterChecker>(
      () => HomeSubAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductDetailAdditionalPagingResultParameterChecker>(
      () => ProductDetailAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductBrandDetailAdditionalPagingResultParameterChecker>(
      () => ProductBrandDetailAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductCategoryDetailAdditionalPagingResultParameterChecker>(
      () => ProductCategoryDetailAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductBundleAdditionalPagingResultParameterChecker>(
      () => ProductBundleAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<ProductBundleDetailAdditionalPagingResultParameterChecker>(
      () => ProductBundleDetailAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<WishlistSubAdditionalPagingResultParameterChecker>(
      () => WishlistSubAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<FeedSubAdditionalPagingResultParameterChecker>(
      () => FeedSubAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<CouponAdditionalPagingResultParameterChecker>(
      () => CouponAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<MenuMainMenuSubAdditionalPagingResultParameterChecker>(
      () => MenuMainMenuSubAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<CartAdditionalPagingResultParameterChecker>(
      () => CartAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<TakeFriendCartAdditionalPagingResultParameterChecker>(
      () => TakeFriendCartAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<HostCartAdditionalPagingResultParameterChecker>(
      () => HostCartAdditionalPagingResultParameterChecker()
    );
    locator.registerFactory<SharedCartAdditionalPagingResultParameterChecker>(
      () => SharedCartAdditionalPagingResultParameterChecker()
    );

    // Controller Content Delegate
    locator.registerFactory<WishlistAndCartControllerContentDelegate>(
      () => WishlistAndCartControllerContentDelegate(
        addWishlistUseCase: locator(),
        removeWishlistUseCase: locator(),
        addToCartUseCase: locator(),
        removeWishlistBasedProductUseCase: locator(),
        removeFromCartUseCase: locator(),
        removeFromCartDirectlyUseCase: locator(),
        getCartListIgnoringLoginErrorUseCase: locator()
      )
    );
    locator.registerFactory<ProductBrandFavoriteControllerContentDelegate>(
      () => ProductBrandFavoriteControllerContentDelegate(
        addToFavoriteProductBrandUseCase: locator(),
        removeFromFavoriteProductBrandUseCase: locator(),
        getFavoriteProductBrandListUseCase: locator(),
      )
    );
    locator.registerFactory<RepurchaseControllerContentDelegate>(
      () => RepurchaseControllerContentDelegate(
        repurchaseUseCase: locator()
      )
    );
    locator.registerFactory<SharedCartControllerContentDelegate>(
      () => SharedCartControllerContentDelegate(
        checkBucketUseCase: locator()
      )
    );
    locator.registerFactory<ArrivedOrderControllerContentDelegate>(
      () => ArrivedOrderControllerContentDelegate(
        arrivedOrderUseCase: locator()
      )
    );

    // Controller Delegate Factory
    locator.registerLazySingleton<WishlistAndCartDelegateFactory>(
      () => WishlistAndCartDelegateFactory()
    );
    locator.registerLazySingleton<ProductBrandFavoriteDelegateFactory>(
      () => ProductBrandFavoriteDelegateFactory()
    );
    locator.registerLazySingleton<RepurchaseDelegateFactory>(
      () => RepurchaseDelegateFactory()
    );
    locator.registerLazySingleton<SharedCartDelegateFactory>(
      () => SharedCartDelegateFactory()
    );
    locator.registerLazySingleton<ArrivedOrderDelegateFactory>(
      () => ArrivedOrderDelegateFactory()
    );

    // Default Load Data Result Widget
    locator.registerLazySingleton<DefaultLoadDataResultWidget>(() => MainDefaultLoadDataResultWidget());

    // Use Case
    locator.registerLazySingleton<LoginUseCase>(() => LoginUseCase(userRepository: locator()));
    locator.registerLazySingleton<LoginWithGoogleUseCase>(() => LoginWithGoogleUseCase(userRepository: locator()));
    locator.registerLazySingleton<LoginWithAppleUseCase>(() => LoginWithAppleUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterFirstStepUseCase>(() => RegisterFirstStepUseCase(userRepository: locator()));
    locator.registerLazySingleton<VerifyRegisterUseCase>(() => VerifyRegisterUseCase(userRepository: locator()));
    locator.registerLazySingleton<SendRegisterOtpUseCase>(() => SendRegisterOtpUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterSecondStepUseCase>(() => RegisterSecondStepUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterWithGoogleUseCase>(() => RegisterWithGoogleUseCase(userRepository: locator()));
    locator.registerLazySingleton<RegisterWithAppleUseCase>(() => RegisterWithAppleUseCase(userRepository: locator()));
    locator.registerLazySingleton<SendDeleteAccountOtpUseCase>(() => SendDeleteAccountOtpUseCase(userRepository: locator()));
    locator.registerLazySingleton<VerifyDeleteAccountOtpUseCase>(() => VerifyDeleteAccountOtpUseCase(userRepository: locator()));
    locator.registerLazySingleton<AuthIdentityChangeInputUseCase>(() => AuthIdentityChangeInputUseCase(userRepository: locator()));
    locator.registerLazySingleton<AuthIdentityChangeUseCase>(() => AuthIdentityChangeUseCase(userRepository: locator()));
    locator.registerLazySingleton<AuthIdentityChangeVerifyOtpUseCase>(() => AuthIdentityChangeVerifyOtpUseCase(userRepository: locator()));
    locator.registerLazySingleton<AuthIdentitySendVerifyOtpUseCase>(() => AuthIdentitySendVerifyOtpUseCase(userRepository: locator()));
    locator.registerLazySingleton<AuthIdentityUseCase>(() => AuthIdentityUseCase(userRepository: locator()));
    locator.registerLazySingleton<AuthIdentityVerifyOtpUseCase>(() => AuthIdentityVerifyOtpUseCase(userRepository: locator()));
    locator.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(userRepository: locator()));
    locator.registerLazySingleton<ChangePasswordUseCase>(() => ChangePasswordUseCase(userRepository: locator()));
    locator.registerLazySingleton<ModifyPinUseCase>(() => ModifyPinUseCase(userRepository: locator()));
    locator.registerLazySingleton<CheckActivePinUseCase>(() => CheckActivePinUseCase(userRepository: locator()));
    locator.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(userRepository: locator()));
    locator.registerLazySingleton<GetUserAndLoadedRelatedUserDataUseCase>(
      () => GetUserAndLoadedRelatedUserDataUseCase(
        userRepository: locator(),
        addressRepository: locator()
      )
    );
    locator.registerLazySingleton<EditUserUseCase>(() => EditUserUseCase(userRepository: locator()));
    locator.registerLazySingleton<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(userRepository: locator()));
    locator.registerLazySingleton<WhatsappForgotPasswordUseCase>(() => WhatsappForgotPasswordUseCase(userRepository: locator()));
    locator.registerLazySingleton<CheckResetPasswordUseCase>(() => CheckResetPasswordUseCase(userRepository: locator()));
    locator.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase(userRepository: locator()));
    locator.registerLazySingleton<GetProductBrandListUseCase>(() => GetProductBrandListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBrandPagingUseCase>(() => GetProductBrandPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetFavoriteProductBrandPagingUseCase>(() => GetFavoriteProductBrandPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetFavoriteProductBrandListUseCase>(() => GetFavoriteProductBrandListUseCase(productRepository: locator()));
    locator.registerLazySingleton<AddToFavoriteProductBrandUseCase>(() => AddToFavoriteProductBrandUseCase(productRepository: locator()));
    locator.registerLazySingleton<RemoveFromFavoriteProductBrandUseCase>(() => RemoveFromFavoriteProductBrandUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductListUseCase>(() => GetProductListUseCase(productRepository: locator()));
    locator.registerLazySingleton<ShareProductUseCase>(() => ShareProductUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductViralListUseCase>(() => GetProductViralListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductViralPagingUseCase>(() => GetProductViralPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductEntryWithConditionPagingUseCase>(() => GetProductEntryWithConditionPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductEntryHeaderContentUseCase>(() => GetProductEntryHeaderContentUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailUseCase>(() => GetProductDetailUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailBySlugUseCase>(() => GetProductDetailBySlugUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailOtherChosenForYouProductEntryListUseCase>(() => GetProductDetailOtherChosenForYouProductEntryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailOtherFromThisBrandProductEntryListUseCase>(() => GetProductDetailOtherFromThisBrandProductEntryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailOtherInThisCategoryProductEntryListUseCase>(() => GetProductDetailOtherInThisCategoryProductEntryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailFromYourSearchProductEntryListUseCase>(() => GetProductDetailFromYourSearchProductEntryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDetailOtherInterestedProductBrandListUseCase>(() => GetProductDetailOtherInterestedProductBrandListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductCategoryListUseCase>(() => GetProductCategoryListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductCategoryPagingUseCase>(() => GetProductCategoryPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductCategoryDetailUseCase>(() => GetProductCategoryDetailUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundleListUseCase>(() => GetProductBundleListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundlePagingUseCase>(() => GetProductBundlePagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundleHighlightUseCase>(() => GetProductBundleHighlightUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundleDetailUseCase>(() => GetProductBundleDetailUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductBundleDetailBySlugUseCase>(() => GetProductBundleDetailBySlugUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetSupportDiscussionUseCase>(() => GetSupportDiscussionUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetProductDiscussionUseCase>(() => GetProductDiscussionUseCase(productDiscussionRepository: locator()));
    locator.registerLazySingleton<GetProductDiscussionBasedUserUseCase>(() => GetProductDiscussionBasedUserUseCase(productDiscussionRepository: locator()));
    locator.registerLazySingleton<CreateProductDiscussionUseCase>(() => CreateProductDiscussionUseCase(productDiscussionRepository: locator()));
    locator.registerLazySingleton<ReplyProductDiscussionUseCase>(() => ReplyProductDiscussionUseCase(productDiscussionRepository: locator()));
    locator.registerLazySingleton<GetWishlistPagingUseCase>(() => GetWishlistPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetWishlistListUseCase>(() => GetWishlistListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetWishlistListIgnoringLoginErrorUseCase>(() => GetWishlistListIgnoringLoginErrorUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetSnackForLyingAroundListUseCase>(() => GetSnackForLyingAroundListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetBestsellerInMasterbagasiListUseCase>(() => GetBestsellerInMasterbagasiListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetSelectedFashionBrandsListUseCase>(() => GetSelectedFashionBrandsListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetSelectedFashionBrandsPagingUseCase>(() => GetSelectedFashionBrandsPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetSelectedBeautyBrandsListUseCase>(() => GetSelectedBeautyBrandsListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetSelectedBeautyBrandsPagingUseCase>(() => GetSelectedBeautyBrandsPagingUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetCoffeeAndTeaOriginIndonesiaListUseCase>(() => GetCoffeeAndTeaOriginIndonesiaListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetReadyToEatStreetFoodStyleListUseCase>(() => GetReadyToEatStreetFoodStyleListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetBeautyProductIndonesiaListUseCase>(() => GetBeautyProductIndonesiaListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetFashionProductIndonesiaListUseCase>(() => GetFashionProductIndonesiaListUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetOnlyForYouListUseCase>(() => GetOnlyForYouListUseCase(productRepository: locator()));
    locator.registerLazySingleton<AddWishlistUseCase>(() => AddWishlistUseCase(productRepository: locator()));
    locator.registerLazySingleton<RemoveWishlistUseCase>(() => RemoveWishlistUseCase(productRepository: locator()));
    locator.registerLazySingleton<RemoveWishlistBasedProductUseCase>(() => RemoveWishlistBasedProductUseCase(productRepository: locator()));
    locator.registerLazySingleton<GetShortVideoUseCase>(() => GetShortVideoUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetShortVideoPagingUseCase>(() => GetShortVideoPagingUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetDeliveryReviewUseCase>(() => GetDeliveryReviewUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetWaitingToBeReviewedDeliveryReviewPagingUseCase>(() => GetWaitingToBeReviewedDeliveryReviewPagingUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetHistoryDeliveryReviewListUseCase>(() => GetHistoryDeliveryReviewListUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetCheckYourContributionDeliveryReviewDetailUseCase>(() => GetCheckYourContributionDeliveryReviewDetailUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GiveReviewDeliveryReviewDetailUseCase>(() => GiveReviewDeliveryReviewDetailUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetCountryDeliveryReviewUseCase>(() => GetCountryDeliveryReviewUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetNewsUseCase>(() => GetNewsUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetNewsPagingUseCase>(() => GetNewsPagingUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetNewsDetailUseCase>(() => GetNewsDetailUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetTripDefaultVideoUseCase>(() => GetTripDefaultVideoUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetTripDefaultVideoPagingUseCase>(() => GetTripDefaultVideoPagingUseCase(feedRepository: locator()));
    locator.registerLazySingleton<GetKitchenContentsBannerUseCase>(() => GetKitchenContentsBannerUseCase(bannerRepository: locator()));
    locator.registerLazySingleton<GetHandycraftsContentsBannerUseCase>(() => GetHandycraftsContentsBannerUseCase(bannerRepository: locator()));
    locator.registerLazySingleton<GetHomepageContentsBannerUseCase>(() => GetHomepageContentsBannerUseCase(bannerRepository: locator()));
    locator.registerLazySingleton<GetShippingPriceContentsBannerUseCase>(() => GetShippingPriceContentsBannerUseCase(bannerRepository: locator()));
    locator.registerLazySingleton<GetSponsorContentsBannerUseCase>(() => GetSponsorContentsBannerUseCase(bannerRepository: locator()));
    locator.registerLazySingleton<GetCouponPagingUseCase>(() => GetCouponPagingUseCase(couponRepository: locator()));
    locator.registerLazySingleton<GetCouponListUseCase>(() => GetCouponListUseCase(couponRepository: locator()));
    locator.registerLazySingleton<GetCouponDetailUseCase>(() => GetCouponDetailUseCase(couponRepository: locator()));
    locator.registerLazySingleton<GetCouponTacListUseCase>(() => GetCouponTacListUseCase(couponRepository: locator()));
    locator.registerLazySingleton<CheckCouponUseCase>(() => CheckCouponUseCase(couponRepository: locator()));
    locator.registerLazySingleton<GetShortMyCartUseCase>(() => GetShortMyCartUseCase(cartRepository: locator()));
    locator.registerLazySingleton<GetCartListUseCase>(() => GetCartListUseCase(cartRepository: locator()));
    locator.registerLazySingleton<GetCartListIgnoringLoginErrorUseCase>(() => GetCartListIgnoringLoginErrorUseCase(cartRepository: locator()));
    locator.registerLazySingleton<GetMyCartUseCase>(() => GetMyCartUseCase(cartRepository: locator()));
    locator.registerLazySingleton<AddToCartUseCase>(() => AddToCartUseCase(cartRepository: locator()));
    locator.registerLazySingleton<RemoveFromCartUseCase>(() => RemoveFromCartUseCase(cartRepository: locator()));
    locator.registerLazySingleton<RemoveFromCartDirectlyUseCase>(() => RemoveFromCartDirectlyUseCase(cartRepository: locator()));
    locator.registerLazySingleton<UpdateCartQuantityUseCase>(() => UpdateCartQuantityUseCase(cartRepository: locator()));
    locator.registerLazySingleton<AddHostCartUseCase>(() => AddHostCartUseCase(cartRepository: locator()));
    locator.registerLazySingleton<TakeFriendCartUseCase>(() => TakeFriendCartUseCase(cartRepository: locator()));
    locator.registerLazySingleton<GetCountryBasedCountryCodeUseCase>(() => GetCountryBasedCountryCodeUseCase(addressRepository: locator()));
    locator.registerLazySingleton<GetCurrentSelectedAddressUseCase>(() => GetCurrentSelectedAddressUseCase(addressRepository: locator()));
    locator.registerLazySingleton<GetAddressBasedIdUseCase>(() => GetAddressBasedIdUseCase(addressRepository: locator()));
    locator.registerLazySingleton<GetAddressListUseCase>(() => GetAddressListUseCase(addressRepository: locator()));
    locator.registerLazySingleton<GetAddressPagingUseCase>(() => GetAddressPagingUseCase(addressRepository: locator()));
    locator.registerLazySingleton<UpdateCurrentSelectedAddressUseCase>(() => UpdateCurrentSelectedAddressUseCase(addressRepository: locator()));
    locator.registerLazySingleton<AddAddressUseCase>(() => AddAddressUseCase(addressRepository: locator()));
    locator.registerLazySingleton<ChangeAddressUseCase>(() => ChangeAddressUseCase(addressRepository: locator()));
    locator.registerLazySingleton<RemoveAddressUseCase>(() => RemoveAddressUseCase(addressRepository: locator()));
    locator.registerLazySingleton<GetCartSummaryUseCase>(() => GetCartSummaryUseCase(cartRepository: locator()));
    locator.registerLazySingleton<GetAdditionalItemUseCase>(() => GetAdditionalItemUseCase(cartRepository: locator()));
    locator.registerLazySingleton<AddAdditionalItemUseCase>(() => AddAdditionalItemUseCase(cartRepository: locator()));
    locator.registerLazySingleton<ChangeAdditionalItemUseCase>(() => ChangeAdditionalItemUseCase(cartRepository: locator()));
    locator.registerLazySingleton<RemoveAdditionalItemUseCase>(() => RemoveAdditionalItemUseCase(cartRepository: locator()));
    locator.registerLazySingleton<GetProvinceMapUseCase>(() => GetProvinceMapUseCase(mapRepository: locator()));
    locator.registerLazySingleton<CreateOrderUseCase>(() => CreateOrderUseCase(orderRepository: locator()));
    locator.registerLazySingleton<CreateOrderVersion1Point1UseCase>(() => CreateOrderVersion1Point1UseCase(orderRepository: locator()));
    locator.registerLazySingleton<OrderTransactionUseCase>(() => OrderTransactionUseCase(orderRepository: locator()));
    locator.registerLazySingleton<PurchaseDirectUseCase>(() => PurchaseDirectUseCase(orderRepository: locator()));
    locator.registerLazySingleton<RepurchaseUseCase>(() => RepurchaseUseCase(orderRepository: locator()));
    locator.registerLazySingleton<GetOrderPagingUseCase>(() => GetOrderPagingUseCase(orderRepository: locator()));
    locator.registerLazySingleton<GetShippingReviewOrderListUseCase>(() => GetShippingReviewOrderListUseCase(orderRepository: locator()));
    locator.registerLazySingleton<GetOrderBasedIdUseCase>(() => GetOrderBasedIdUseCase(orderRepository: locator()));
    locator.registerLazySingleton<ArrivedOrderUseCase>(() => ArrivedOrderUseCase(orderRepository: locator()));
    locator.registerLazySingleton<ModifyWarehouseInOrderUseCase>(() => ModifyWarehouseInOrderUseCase(orderRepository: locator()));
    locator.registerLazySingleton<CheckRatesForVariousCountriesUseCase>(() => CheckRatesForVariousCountriesUseCase(cargoRepository: locator()));
    locator.registerLazySingleton<GetCountryListUseCase>(() => GetCountryListUseCase(addressRepository: locator()));
    locator.registerLazySingleton<GetCountryPagingUseCase>(() => GetCountryPagingUseCase(addressRepository: locator()));
    locator.registerLazySingleton<GetFaqListUseCase>(() => GetFaqListUseCase(faqRepository: locator()));
    locator.registerLazySingleton<AnswerHelpConversationUseCase>(() => AnswerHelpConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<AnswerHelpConversationVersion1Point1UseCase>(() => AnswerHelpConversationVersion1Point1UseCase(chatRepository: locator()));
    locator.registerLazySingleton<CreateHelpConversationUseCase>(() => CreateHelpConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<UpdateReadStatusHelpConversationUseCase>(() => UpdateReadStatusHelpConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetHelpMessageByUserUseCase>(() => GetHelpMessageByUserUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetHelpMessageByConversationUseCase>(() => GetHelpMessageByConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetHelpMessageNotificationCountUseCase>(() => GetHelpMessageNotificationCountUseCase(chatRepository: locator()));
    locator.registerLazySingleton<AnswerOrderConversationUseCase>(() => AnswerOrderConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<AnswerOrderConversationVersion1Point1UseCase>(() => AnswerOrderConversationVersion1Point1UseCase(chatRepository: locator()));
    locator.registerLazySingleton<CreateOrderConversationUseCase>(() => CreateOrderConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<UpdateReadStatusOrderConversationUseCase>(() => UpdateReadStatusOrderConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetOrderMessageByUserUseCase>(() => GetOrderMessageByUserUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetOrderMessageByConversationUseCase>(() => GetOrderMessageByConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetOrderMessageByCombinedOrderUseCase>(() => GetOrderMessageByCombinedOrderUseCase(chatRepository: locator()));
    locator.registerLazySingleton<AnswerProductConversationUseCase>(() => AnswerProductConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<CreateProductConversationUseCase>(() => CreateProductConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<UpdateReadStatusProductConversationUseCase>(() => UpdateReadStatusProductConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetProductMessageByUserUseCase>(() => GetProductMessageByUserUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetProductMessageByConversationUseCase>(() => GetProductMessageByConversationUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetProductMessageByProductUseCase>(() => GetProductMessageByProductUseCase(chatRepository: locator()));
    locator.registerLazySingleton<HelpChatTemplateUseCase>(() => HelpChatTemplateUseCase(chatRepository: locator()));
    locator.registerLazySingleton<GetNotificationByUserListUseCase>(() => GetNotificationByUserListUseCase(notificationRepository: locator()));
    locator.registerLazySingleton<GetNotificationByUserPagingUseCase>(() => GetNotificationByUserPagingUseCase(notificationRepository: locator()));
    locator.registerLazySingleton<GetTransactionNotificationDetailUseCase>(() => GetTransactionNotificationDetailUseCase(notificationRepository: locator()));
    locator.registerLazySingleton<NotificationOrderStatusUseCase>(() => NotificationOrderStatusUseCase(notificationRepository: locator()));
    locator.registerLazySingleton<ReadAllNotificationUseCase>(() => ReadAllNotificationUseCase(notificationRepository: locator()));
    locator.registerLazySingleton<ReadTransactionNotificationUseCase>(() => ReadTransactionNotificationUseCase(notificationRepository: locator()));
    locator.registerLazySingleton<ShowBucketByIdUseCase>(() => ShowBucketByIdUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<CreateBucketUseCase>(() => CreateBucketUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<RequestJoinBucketUseCase>(() => RequestJoinBucketUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<ApproveOrRejectRequestBucketUseCase>(() => ApproveOrRejectRequestBucketUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<RemoveMemberBucketUseCase>(() => RemoveMemberBucketUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<CheckBucketUseCase>(() => CheckBucketUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<TriggerBucketReadyUseCase>(() => TriggerBucketReadyUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<GetSharedCartSummaryUseCase>(() => GetSharedCartSummaryUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<CheckoutBucketUseCase>(() => CheckoutBucketUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<CheckoutBucketVersion1Point1UseCase>(() => CheckoutBucketVersion1Point1UseCase(bucketRepository: locator()));
    locator.registerLazySingleton<LeaveBucketUseCase>(() => LeaveBucketUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<DestroyBucketUseCase>(() => DestroyBucketUseCase(bucketRepository: locator()));
    locator.registerLazySingleton<SearchUseCase>(() => SearchUseCase(searchRepository: locator()));
    locator.registerLazySingleton<SearchHistoryUseCase>(() => SearchHistoryUseCase(searchRepository: locator()));
    locator.registerLazySingleton<SearchLastSeenHistoryUseCase>(() => SearchLastSeenHistoryUseCase(searchRepository: locator()));
    locator.registerLazySingleton<RemoveAllSearchHistoryUseCase>(() => RemoveAllSearchHistoryUseCase(searchRepository: locator()));
    locator.registerLazySingleton<StoreKeywordForSearchHistoryUseCase>(() => StoreKeywordForSearchHistoryUseCase(searchRepository: locator()));
    locator.registerLazySingleton<StoreSearchLastSeenHistoryUseCase>(() => StoreSearchLastSeenHistoryUseCase(searchRepository: locator()));
    locator.registerLazySingleton<PaymentMethodListUseCase>(() => PaymentMethodListUseCase(paymentRepository: locator()));
    locator.registerLazySingleton<PaymentInstructionUseCase>(() => PaymentInstructionUseCase(paymentRepository: locator()));
    locator.registerLazySingleton<ShippingPaymentUseCase>(() => ShippingPaymentUseCase(paymentRepository: locator()));
    locator.registerLazySingleton<ShipperAddressUseCase>(() => ShipperAddressUseCase(addressRepository: locator()));
    locator.registerLazySingleton<AllVersioningUseCase>(() => AllVersioningUseCase(versioningRepository: locator()));
    locator.registerLazySingleton<VersioningBasedFilterUseCase>(() => VersioningBasedFilterUseCase(versioningRepository: locator()));
    locator.registerLazySingleton<ThirdPartyLoginVisibilityUseCase>(() => ThirdPartyLoginVisibilityUseCase(versioningRepository: locator()));
    locator.registerLazySingleton<LoginOrRegisterWithAppleViaCallbackUseCase>(() => LoginOrRegisterWithAppleViaCallbackUseCase(userRepository: locator()));

    // Repository
    locator.registerLazySingleton<UserRepository>(() => DefaultUserRepository(userDataSource: locator()));
    locator.registerLazySingleton<FeedRepository>(() => DefaultFeedRepository(feedDataSource: locator()));
    locator.registerLazySingleton<BannerRepository>(() => DefaultBannerRepository(bannerDataSource: locator()));
    locator.registerLazySingleton<ProductRepository>(
      () => DefaultProductRepository(
        productDataSource: locator(),
        mapDataSource: locator()
      )
    );
    locator.registerLazySingleton<ProductDiscussionRepository>(
      () => DefaultProductDiscussionRepository(
        productDiscussionDataSource: locator()
      )
    );
    locator.registerLazySingleton<CouponRepository>(() => DefaultCouponRepository(couponDataSource: locator()));
    locator.registerLazySingleton<CartRepository>(() => DefaultCartRepository(cartDataSource: locator()));
    locator.registerLazySingleton<AddressRepository>(() => DefaultAddressRepository(addressDataSource: locator()));
    locator.registerLazySingleton<MapRepository>(() => DefaultMapRepository(mapDataSource: locator()));
    locator.registerLazySingleton<OrderRepository>(() => DefaultOrderRepository(orderDataSource: locator()));
    locator.registerLazySingleton<CargoRepository>(() => DefaultCargoRepository(cargoDataSource: locator()));
    locator.registerLazySingleton<FaqRepository>(() => DefaultFaqRepository(faqDataSource: locator()));
    locator.registerLazySingleton<ChatRepository>(() => DefaultChatRepository(chatDataSource: locator()));
    locator.registerLazySingleton<NotificationRepository>(() => DefaultNotificationRepository(notificationDataSource: locator()));
    locator.registerLazySingleton<BucketRepository>(() => DefaultBucketRepository(bucketDataSource: locator()));
    locator.registerLazySingleton<SearchRepository>(() => DefaultSearchRepository(searchDataSource: locator()));
    locator.registerLazySingleton<PaymentRepository>(() => DefaultPaymentRepository(paymentDataSource: locator()));
    locator.registerLazySingleton<VersioningRepository>(() => DefaultVersioningRepository(versioningDataSource: locator()));

    // Data Sources
    locator.registerLazySingleton<UserDataSource>(() => DefaultUserDataSource(dio: locator()));
    locator.registerLazySingleton<BannerDataSource>(() => DefaultBannerDataSource(dio: locator()));
    locator.registerLazySingleton<FeedDataSource>(() => DefaultFeedDataSource(dio: locator()));
    locator.registerLazySingleton<ProductDataSource>(
      () => DefaultProductDataSource(
        dio: locator(),
        cartDataSource: locator(),
        productBundleDummy: locator(),
        productEntryDummy: locator(),
        productBrandDummy: locator()
      )
    );
    locator.registerLazySingleton<ProductDiscussionDataSource>(
      () => DefaultProductDiscussionDataSource(
        dio: locator(),
        userDummy: locator(),
        productEntryDummy: locator()
      )
    );
    locator.registerLazySingleton<CouponDataSource>(() => DefaultCouponDataSource(dio: locator()));
    locator.registerLazySingleton<CartDataSource>(() => DefaultCartDataSource(dio: locator(), cartDummy: locator()));
    locator.registerLazySingleton<AddressDataSource>(() => DefaultAddressDataSource(dio: locator(), addressDummy: locator()));
    locator.registerLazySingleton<MapDataSource>(() => DefaultMapDataSource(dio: locator()));
    locator.registerLazySingleton<OrderDataSource>(() => DefaultOrderDataSource(dio: locator()));
    locator.registerLazySingleton<CargoDataSource>(() => DefaultCargoDataSource(dio: locator()));
    locator.registerLazySingleton<FaqDataSource>(() => DefaultFaqDataSource(dio: locator()));
    locator.registerLazySingleton<ChatDataSource>(() => DefaultChatDataSource(dio: locator()));
    locator.registerLazySingleton<NotificationDataSource>(() => DefaultNotificationDataSource(dio: locator()));
    locator.registerLazySingleton<BucketDataSource>(() => DefaultBucketDataSource(dio: locator()));
    locator.registerLazySingleton<SearchDataSource>(
      () => DefaultSearchDataSource(
        dio: locator(),
        productDataSource: locator(),
        cartDataSource: locator()
      )
    );
    locator.registerLazySingleton<PaymentDataSource>(() => DefaultPaymentDataSource(dio: locator()));
    locator.registerLazySingleton<VersioningDataSource>(() => DefaultVersioningDataSource(dio: locator()));

    // Dio
    locator.registerLazySingleton<Dio>(() => DioHttpClient.of());
  }
}

// ignore: non_constant_identifier_names
final Injector = _Injector();