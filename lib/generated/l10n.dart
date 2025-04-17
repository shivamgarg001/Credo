// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Add Contact`
  String get add_contact {
    return Intl.message('Add Contact', name: 'add_contact', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Or`
  String get or {
    return Intl.message('Or', name: 'or', desc: '', args: []);
  }

  /// `Select Category`
  String get select_category {
    return Intl.message(
      'Select Category',
      name: 'select_category',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message('Customer', name: 'customer', desc: '', args: []);
  }

  /// `Supplier`
  String get supplier {
    return Intl.message('Supplier', name: 'supplier', desc: '', args: []);
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Upload Receipt Photos`
  String get upload_receipt_photos {
    return Intl.message(
      'Upload Receipt Photos',
      name: 'upload_receipt_photos',
      desc: '',
      args: [],
    );
  }

  /// `Submit & Autofill`
  String get submit_and_autofill {
    return Intl.message(
      'Submit & Autofill',
      name: 'submit_and_autofill',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Submit Receipt`
  String get submit_receipt {
    return Intl.message(
      'Submit Receipt',
      name: 'submit_receipt',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `No timestamp available`
  String get no_timestamp_available {
    return Intl.message(
      'No timestamp available',
      name: 'no_timestamp_available',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get approve {
    return Intl.message('Approve', name: 'approve', desc: '', args: []);
  }

  /// `APPROVED`
  String get approved {
    return Intl.message('APPROVED', name: 'approved', desc: '', args: []);
  }

  /// `Update Item`
  String get update_item {
    return Intl.message('Update Item', name: 'update_item', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Rate`
  String get rate {
    return Intl.message('Rate', name: 'rate', desc: '', args: []);
  }

  /// `Transaction Details`
  String get transaction_details {
    return Intl.message(
      'Transaction Details',
      name: 'transaction_details',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `PENDING`
  String get pending {
    return Intl.message('PENDING', name: 'pending', desc: '', args: []);
  }

  /// `Image`
  String get image {
    return Intl.message('Image', name: 'image', desc: '', args: []);
  }

  /// `No image was captured`
  String get no_image_captured {
    return Intl.message(
      'No image was captured',
      name: 'no_image_captured',
      desc: '',
      args: [],
    );
  }

  /// `View Chats`
  String get view_chats {
    return Intl.message('View Chats', name: 'view_chats', desc: '', args: []);
  }

  /// `Are you sure you want to delete this invoice?`
  String get delete_invoice_confirmation {
    return Intl.message(
      'Are you sure you want to delete this invoice?',
      name: 'delete_invoice_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone`
  String get delete_invoice_warning {
    return Intl.message(
      'This action cannot be undone',
      name: 'delete_invoice_warning',
      desc: '',
      args: [],
    );
  }

  /// `Delete Invoice`
  String get delete_invoice {
    return Intl.message(
      'Delete Invoice',
      name: 'delete_invoice',
      desc: '',
      args: [],
    );
  }

  /// `Update Invoice`
  String get update_invoice {
    return Intl.message(
      'Update Invoice',
      name: 'update_invoice',
      desc: '',
      args: [],
    );
  }

  /// `Delete Ledger`
  String get delete_ledger {
    return Intl.message(
      'Delete Ledger',
      name: 'delete_ledger',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this ledger? This action cannot be undone`
  String get delete_ledger_confirmation {
    return Intl.message(
      'Are you sure you want to delete this ledger? This action cannot be undone',
      name: 'delete_ledger_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone`
  String get delete_ledger_warning {
    return Intl.message(
      'This action cannot be undone',
      name: 'delete_ledger_warning',
      desc: '',
      args: [],
    );
  }

  /// `CREATED AT:`
  String get created_at {
    return Intl.message('CREATED AT:', name: 'created_at', desc: '', args: []);
  }

  /// `TOTAL AMOUNT:`
  String get total_amount {
    return Intl.message(
      'TOTAL AMOUNT:',
      name: 'total_amount',
      desc: '',
      args: [],
    );
  }

  /// `TRANSACTIONS`
  String get transactions {
    return Intl.message(
      'TRANSACTIONS',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `ADD RECEIPT`
  String get add_receipt {
    return Intl.message('ADD RECEIPT', name: 'add_receipt', desc: '', args: []);
  }

  /// `Delete this contact`
  String get delete_contact {
    return Intl.message(
      'Delete this contact',
      name: 'delete_contact',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this contact?`
  String get delete_contact_confirmation {
    return Intl.message(
      'Are you sure you want to delete this contact?',
      name: 'delete_contact_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Add Ledger`
  String get add_ledger {
    return Intl.message('Add Ledger', name: 'add_ledger', desc: '', args: []);
  }

  /// `Ledger Name`
  String get ledger_name {
    return Intl.message('Ledger Name', name: 'ledger_name', desc: '', args: []);
  }

  /// `Ledger Details`
  String get ledger_details {
    return Intl.message(
      'Ledger Details',
      name: 'ledger_details',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get welcome_back {
    return Intl.message(
      'Welcome Back',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message('Sign Up', name: 'sign_up', desc: '', args: []);
  }

  /// `This name will be visible to all the people on this app`
  String get name_visible_to_all {
    return Intl.message(
      'This name will be visible to all the people on this app',
      name: 'name_visible_to_all',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Fingerprint authentication failed.`
  String get fingerprint_authentication_failed {
    return Intl.message(
      'Fingerprint authentication failed.',
      name: 'fingerprint_authentication_failed',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Invite a new person`
  String get invite_new_person {
    return Intl.message(
      'Invite a new person',
      name: 'invite_new_person',
      desc: '',
      args: [],
    );
  }

  /// `Share credo with your businessmen friends.`
  String get share_credo {
    return Intl.message(
      'Share credo with your businessmen friends.',
      name: 'share_credo',
      desc: '',
      args: [],
    );
  }

  /// `Net Balance`
  String get net_balance {
    return Intl.message('Net Balance', name: 'net_balance', desc: '', args: []);
  }

  /// `Khata`
  String get khata {
    return Intl.message('Khata', name: 'khata', desc: '', args: []);
  }

  /// `You Get`
  String get you_get {
    return Intl.message('You Get', name: 'you_get', desc: '', args: []);
  }

  /// `You Give`
  String get you_give {
    return Intl.message('You Give', name: 'you_give', desc: '', args: []);
  }

  /// `advance`
  String get advance {
    return Intl.message('advance', name: 'advance', desc: '', args: []);
  }

  /// `Profile photo`
  String get profile_photo {
    return Intl.message(
      'Profile photo',
      name: 'profile_photo',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Ledger`
  String get ledger {
    return Intl.message('Ledger', name: 'ledger', desc: '', args: []);
  }

  /// `Are you sure you want to sign out?`
  String get are_you_sure_sign_out {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'are_you_sure_sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to DELETE your account FOREVER?`
  String get are_you_sure_delete_account {
    return Intl.message(
      'Are you sure you want to DELETE your account FOREVER?',
      name: 'are_you_sure_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `We're sorry to hear you're leaving. We'll do our best to earn your trust`
  String get sorry_to_see_you_go {
    return Intl.message(
      'We\'re sorry to hear you\'re leaving. We\'ll do our best to earn your trust',
      name: 'sorry_to_see_you_go',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion failed`
  String get account_deletion_failed {
    return Intl.message(
      'Account deletion failed',
      name: 'account_deletion_failed',
      desc: '',
      args: [],
    );
  }

  /// `Authenticate to enable fingerprint unlock`
  String get authenticate_for_fingerprint_unlock {
    return Intl.message(
      'Authenticate to enable fingerprint unlock',
      name: 'authenticate_for_fingerprint_unlock',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message('Security', name: 'security', desc: '', args: []);
  }

  /// `Fingerprint Unlock`
  String get fingerprint_unlock {
    return Intl.message(
      'Fingerprint Unlock',
      name: 'fingerprint_unlock',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get sign_out {
    return Intl.message('Sign Out', name: 'sign_out', desc: '', args: []);
  }

  /// `Delete Account Forever`
  String get delete_account_forever {
    return Intl.message(
      'Delete Account Forever',
      name: 'delete_account_forever',
      desc: '',
      args: [],
    );
  }

  /// `Signout`
  String get signOut {
    return Intl.message('Signout', name: 'signOut', desc: '', args: []);
  }

  /// `Invite Others`
  String get inviteOthers {
    return Intl.message(
      'Invite Others',
      name: 'inviteOthers',
      desc: '',
      args: [],
    );
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message('Take Photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Stop Recording`
  String get stopRecording {
    return Intl.message(
      'Stop Recording',
      name: 'stopRecording',
      desc: '',
      args: [],
    );
  }

  /// `Record Audio`
  String get recordAudio {
    return Intl.message(
      'Record Audio',
      name: 'recordAudio',
      desc: '',
      args: [],
    );
  }

  /// `Recorded Audio Preview:`
  String get recordedAudioPreview {
    return Intl.message(
      'Recorded Audio Preview:',
      name: 'recordedAudioPreview',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `CREDIT`
  String get credit {
    return Intl.message('CREDIT', name: 'credit', desc: '', args: []);
  }

  /// `NOTIFICATION`
  String get notification {
    return Intl.message(
      'NOTIFICATION',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Submitting Audio...`
  String get submittingAudio {
    return Intl.message(
      'Submitting Audio...',
      name: 'submittingAudio',
      desc: '',
      args: [],
    );
  }

  /// `Send Money`
  String get sendMoney {
    return Intl.message('Send Money', name: 'sendMoney', desc: '', args: []);
  }

  /// `Success!`
  String get success {
    return Intl.message('Success!', name: 'success', desc: '', args: []);
  }

  /// `Ledger Details`
  String get ledgerDetails {
    return Intl.message(
      'Ledger Details',
      name: 'ledgerDetails',
      desc: '',
      args: [],
    );
  }

  /// `Order Value:`
  String get orderValue {
    return Intl.message('Order Value:', name: 'orderValue', desc: '', args: []);
  }

  /// `Money Received:`
  String get moneyReceived {
    return Intl.message(
      'Money Received:',
      name: 'moneyReceived',
      desc: '',
      args: [],
    );
  }

  /// `Money Sent:`
  String get moneySent {
    return Intl.message('Money Sent:', name: 'moneySent', desc: '', args: []);
  }

  /// `Choose Credo App Language`
  String get chooseCredoAppLanguage {
    return Intl.message(
      'Choose Credo App Language',
      name: 'chooseCredoAppLanguage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'as'),
      Locale.fromSubtags(languageCode: 'gu'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'hn'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'pa'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'te'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
