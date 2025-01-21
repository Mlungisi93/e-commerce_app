import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_screen.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/product_reviews/product_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  Future<void> purchaseOneProduct(Robot r) async {
    // add to cart
    await r.products.selectProduct();
    await r.products.setProductQuantity(3);
    await r.cart.addToCart();
    await r.cart.openCart();
    r.cart.expectFindNCartItems(1);
    // checkout
    await r.checkout.startCheckout();
    await r.auth.enterAndSubmitEmailAndPassword();
    r.cart.expectFindNCartItems(1);
    await r.checkout.startPayment();
    // when a payment is complete, user is taken to the orders page
    r.orders.expectFindNOrders(1);
    await r.closePage(); // close orders page
  }

  testWidgets('purchase product, leave review, update it', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    await purchaseOneProduct(r);
    await r.products.selectProduct();
    // leave review
    r.reviews.expectFindLeaveReview();
    await r.reviews.tapLeaveReviewButton();
    await r.reviews.createAndSubmitReview('Love it!');
    r.reviews.expectFindOneReview();
    r.reviews.expectFindText('Love it!');
    // update review
    r.reviews.expectFindUpdateReview();
    await r.reviews.tapUpdateReviewButton();
    await r.reviews.updateAndSubmitReview('Great!');
    r.reviews.expectFindOneReview();
    r.reviews.expectFindText('Great!');
  });

  testWidgets('leave review screen displays correctly', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    await purchaseOneProduct(r);
    await r.products.selectProduct();
    await r.reviews.tapLeaveReviewButton();
    // Verify the screen displays correctly
    expect(find.text('Leave a review'), findsOneWidget);
    expect(find.byType(ProductRatingBar), findsOneWidget);
    expect(find.byKey(LeaveReviewForm.reviewCommentKey), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('leave review screen allows submitting a review', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    await purchaseOneProduct(r);
    await r.products.selectProduct();
    await r.reviews.tapLeaveReviewButton();
    // Leave a review
    await r.reviews.createAndSubmitReview('Love it!');
    r.reviews.expectFindOneReview();
    r.reviews.expectFindText('Love it!');
  });

  testWidgets('leave review screen allows updating a review', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    await purchaseOneProduct(r);
    await r.products.selectProduct();
    await r.reviews.tapLeaveReviewButton();
    // Leave a review
    await r.reviews.createAndSubmitReview('Love it!');
    r.reviews.expectFindOneReview();
    r.reviews.expectFindText('Love it!');
    // Update the review
    await r.reviews.tapUpdateReviewButton();
    await r.reviews.updateAndSubmitReview('Great!');
    r.reviews.expectFindOneReview();
    r.reviews.expectFindText('Great!');
  });

  // testWidgets('leave review screen shows error on failed submission',
  //     (tester) async {
  //   final r = Robot(tester);
  //   await r.pumpMyApp();
  //   await purchaseOneProduct(r);
  //   await r.products.selectProduct();
  //   await r.reviews.tapLeaveReviewButton();
  //   // Simulate a failed submission
  //   await r.reviews.createAndSubmitReviewWithError('Love it!');
  //   expect(find.text('An error occurred'), findsOneWidget);
  // });
}
