// lib/UI/views/home/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stripe_payment/UI/views/home/home_view_model.dart';
import 'package:stripe_payment/theme/app_theme.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _pulseAnim;

  // ── currencies — PKR included ──
  String _selectedCurrency = 'PKR';
  final List<Map<String, String>> _currencies = [
    {'code': 'PKR', 'symbol': '₨'},
    {'code': 'USD', 'symbol': '\$'},
    {'code': 'EUR', 'symbol': '€'},
    {'code': 'GBP', 'symbol': '£'},
    {'code': 'AED', 'symbol': 'د.إ'},
  ];

  String get _currencySymbol =>
      _currencies.firstWhere((c) => c['code'] == _selectedCurrency)['symbol']!;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(
        parent: _fadeController, curve: Curves.easeOut);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _slideController, curve: Curves.easeOutCubic));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.025).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentViewModel>.reactive(
      viewModelBuilder: () => PaymentViewModel(),
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppColors.bgPage,
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildProfileCard(),
                      const SizedBox(height: 20),
                      _buildBalanceCard(),
                      const SizedBox(height: 28),
                      _buildAmountSection(),
                      const SizedBox(height: 20),
                      _buildCurrencySelector(),
                      const SizedBox(height: 28),
                      if (model.paymentSuccess) _buildSuccessBanner(),
                      if (model.errorMessage.isNotEmpty)
                        _buildErrorBanner(model.errorMessage),
                      const SizedBox(height: 4),
                      _buildPayButton(model),
                      const SizedBox(height: 24),
                      _buildSecurityFooter(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  HEADER — App logo + notification
  // ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: const Center(
                child: Text('V',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5)),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VaultPay', style: AppTextStyles.h1),
                Text('Secure. Instant. Global.',
                    style: AppTextStyles.labelSmall),
              ],
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.notifications_none_rounded,
              size: 20, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  PROFILE CARD — Hammad Nasir ka account
  // ─────────────────────────────────────────────
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            ),
            child: const Center(
              child: Text(
                'HN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Name + greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good day, Hammad! 👋',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text('Hammad Nasir',
                    style: AppTextStyles.h3
                        .copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 1),
                Text('hammad.nasir@gmail.com',
                    style: AppTextStyles.labelSmall),
              ],
            ),
          ),
          // Verified badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius:
                  BorderRadius.circular(AppDimens.radiusFull),
              border: Border.all(color: AppColors.successBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded,
                    color: AppColors.success, size: 12),
                const SizedBox(width: 4),
                Text('Verified',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.successText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BALANCE CARD (overflow fixed) ─────────────────────────────────────────
// Replace your existing _buildBalanceCard() with this

Widget _buildBalanceCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppDimens.spaceLg),
    decoration: BoxDecoration(
      color: AppColors.cardDark,
      borderRadius: BorderRadius.circular(AppDimens.radiusXl),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Row 1: Label + Active pill ──────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Balance',
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.cardLabel),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cardDarkSurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.positive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Active',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.positive),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Row 2: Balance amount ────────────────────────────────────────
        Text('PKR 21,233,480.50', style: AppTextStyles.displayLarge),

        const SizedBox(height: 16),

        // ── Row 3: Tickers (Flexible) ────────────────────────────────────
        Row(
          children: [
            Flexible(
              child: _tickerChip(
                Icons.arrow_upward_rounded,
                '+PKR 240',
                AppColors.positive,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: _tickerChip(
                Icons.arrow_downward_rounded,
                '-PKR 80',
                AppColors.negative,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Row 4: Stripe pill (separate row, right-aligned) ─────────────
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardDarkSurface,
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.credit_card_rounded,
                    color: AppColors.accent, size: 14),
                SizedBox(width: 4),
                Text(
                  'Stripe',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ── TICKER CHIP helper ─────────────────────────────────────────────────────
Widget _tickerChip(IconData icon, String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color, size: 13),
      const SizedBox(width: 3),
      Flexible(
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(width: 3),
      const Text(
        'today',
        style: TextStyle(color: Color(0xFF6B6B80), fontSize: 11),
      ),
    ],
  );
}
  // ─────────────────────────────────────────────
  //  AMOUNT INPUT
  // ─────────────────────────────────────────────
  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Send Amount', style: AppTextStyles.labelLarge),
        const SizedBox(height: 12),
        Container(
          height: AppDimens.inputHeight,
          decoration: BoxDecoration(
            color: AppColors.bgInput,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  _currencySymbol,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  style: AppTextStyles.amountInput,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: AppTextStyles.amountInput
                        .copyWith(color: AppColors.textHint),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Quick chips
        Row(
          children: [
            _selectedCurrency == 'PKR' ? '₨500' : '\$10',
            _selectedCurrency == 'PKR' ? '₨1000' : '\$25',
            _selectedCurrency == 'PKR' ? '₨2000' : '\$50',
            _selectedCurrency == 'PKR' ? '₨5000' : '\$100',
          ].map((amt) {
            final numVal = amt.replaceAll(RegExp(r'[^\d]'), '');
            return GestureDetector(
              onTap: () {
                setState(() => _amountController.text = numVal);
                HapticFeedback.selectionClick();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius:
                      BorderRadius.circular(AppDimens.radiusFull),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Text(amt,
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  CURRENCY SELECTOR  (PKR included)
  // ─────────────────────────────────────────────
  Widget _buildCurrencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Currency', style: AppTextStyles.labelLarge),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _currencies.map((curr) {
              final isSelected = _selectedCurrency == curr['code'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCurrency = curr['code']!;
                    _amountController.clear();
                  });
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.bgCard,
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusMd),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        curr['symbol']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        curr['code']!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white70
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  SUCCESS BANNER
  // ─────────────────────────────────────────────
  Widget _buildSuccessBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.successBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text('Payment successful! Funds are on their way.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.successText,
                        fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  ERROR BANNER
  // ─────────────────────────────────────────────
  Widget _buildErrorBanner(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.errorText,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  PAY BUTTON  — same functionality, no changes
  // ─────────────────────────────────────────────
  Widget _buildPayButton(PaymentViewModel model) {
    final rawAmount = _amountController.text;
    final parsedAmount = double.tryParse(rawAmount) ?? 0.0;
    final amountInCents = (parsedAmount * 100).toInt();
    final isReady = amountInCents > 0 && !model.isBusy;

    return ScaleTransition(
      scale: _pulseAnim,
      child: GestureDetector(
        onTap: isReady
            ? () {
                HapticFeedback.mediumImpact();
                model.processPayment(
                  amount: amountInCents,
                  currency: _selectedCurrency.toLowerCase(),
                );
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: AppDimens.buttonHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isReady ? AppColors.primary : AppColors.borderLight,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          ),
          child: Center(
            child: model.isBusy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_rounded,
                          color: isReady
                              ? Colors.white
                              : AppColors.textMuted,
                          size: 16),
                      const SizedBox(width: 8),
                      Text(
                        amountInCents > 0
                            ? 'Pay $_currencySymbol${parsedAmount.toStringAsFixed(2)}'
                            : 'Enter an amount',
                        style: AppTextStyles.button.copyWith(
                          color: isReady
                              ? Colors.white
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SECURITY FOOTER
  // ─────────────────────────────────────────────
  Widget _buildSecurityFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _secBadge(Icons.shield_outlined, 'SSL Secured'),
            const SizedBox(width: 20),
            _secBadge(Icons.verified_outlined, 'PCI Compliant'),
            const SizedBox(width: 20),
            _secBadge(Icons.lock_outline_rounded, 'Encrypted'),
          ],
        ),
        const SizedBox(height: 12),
        Text('Powered by Stripe  ·  256-bit AES encryption',
            style: AppTextStyles.labelSmall,
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _secBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}