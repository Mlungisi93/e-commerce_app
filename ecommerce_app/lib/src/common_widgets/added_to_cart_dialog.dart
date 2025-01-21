// import 'package:ecommerce_app/src/routing/app_router.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class AddedToCartScreen extends StatelessWidget {
//   final String productName;
//   final String productImage;
//   final double productPrice;

//   AddedToCartScreen({
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final PageController relatedProductsController = PageController();
//     final PageController customersAlsoBoughtController = PageController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Added to Cart'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: constraints.maxHeight,
//               ),
//               child: IntrinsicHeight(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Product Info
//                       Row(
//                         children: [
//                           Image.network(
//                             productImage,
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.cover,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   productName,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   "\$${productPrice.toStringAsFixed(2)}",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       // Buttons
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text("Continue Shopping"),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               context.goNamed(AppRoute.cart.name);
//                             },
//                             child: const Text("Go to Cart"),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       // Related Products
//                       const Text(
//                         "Related Products",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildProductScrollList(
//                         controller: relatedProductsController,
//                         itemCount: 9,
//                       ),
//                       const SizedBox(height: 16),
//                       // Customers Also Bought
//                       const Text(
//                         "Customers Also Bought",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildProductScrollList(
//                         controller: customersAlsoBoughtController,
//                         itemCount: 9,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProductScrollList({
//     required PageController controller,
//     required int itemCount,
//   }) {
//     return SizedBox(
//       height: 250,
//       child: PageView.builder(
//         controller: controller,
//         itemCount: (itemCount / 3).ceil(),
//         itemBuilder: (context, pageIndex) {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(3, (index) {
//               int itemIndex = pageIndex * 3 + index;
//               if (itemIndex >= itemCount) return Container();
//               return Expanded(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       color: Colors.grey[300],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Item $itemIndex",
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           );
//         },
//       ),
//     );
//   }
// }

// void showAddedToCartDialog(BuildContext context, String productName,
//     String productImage, double productPrice) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (context) => AddedToCartScreen(
//       productName: productName,
//       productImage: productImage,
//       productPrice: productPrice,
//     ),
//   );
// }

import 'package:flutter/material.dart';

class AddedToCartScreen extends StatelessWidget {
  final String productName;
  final String productDescription;
  final String productImageUrl;
  final String buttonText;
  final VoidCallback onButtonPressed;

  AddedToCartScreen({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productImageUrl,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Added to cart",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Product Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Product Image
                  Image.network(
                    productImageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Product Description
                        Text(
                          productDescription,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Button
                  ElevatedButton(
                    onPressed: onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),

            // Scrollable Sections
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flying Off Our Shelves
                    buildHorizontalProductList(
                      "Flying Off Our Shelves",
                      isSmallScreen: isSmallScreen,
                    ),

                    // Complementary Considerations
                    buildHorizontalProductList(
                      "Complementary Considerations",
                      isSmallScreen: isSmallScreen,
                    ),

                    // Related Products
                    buildHorizontalProductList(
                      "Related Products",
                      isSmallScreen: isSmallScreen,
                    ),

                    // Customers Also Bought
                    buildHorizontalProductList(
                      "Customers Also Bought",
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.white,
//     body: SafeArea(
//       child: Column(
//         children: [
//           // Header Section
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Added to cart",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//           ),

//           // Product Info Section
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               children: [
//                 // Product Image
//                 Image.network(
//                   productImageUrl,
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//                 const SizedBox(width: 16),

//                 // Product Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Product Name
//                       Text(
//                         productName,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),

//                       // Product Description
//                       Text(
//                         productDescription,
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),

//                 // Button
//                 ElevatedButton(
//                   onPressed: onButtonPressed,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(buttonText),
//                 ),
//               ],
//             ),
//           ),

//           // Scrollable Sections
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Related Products Section
//                   buildSectionTitle("Related Products", "Sponsored"),
//                   buildHorizontalProductList(),

//                   // Customers Also Bought Section
//                   buildSectionTitle("Customers Also Bought", null),
//                   buildHorizontalProductList(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

Widget buildSectionTitle(String title, String? subtitle) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
      ],
    ),
  );
}

// Widget buildHorizontalProductList() {
//   return SizedBox(
//     height: 150,
//     child: ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: 20,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey[300],
//                 ),
//                 child: Center(
//                   child: Text("Image"),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Product $index",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "R ${(100 + index * 10).toString()}",
//                 style: TextStyle(fontSize: 12, color: Colors.green),
//               ),
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }

// Widget buildHorizontalProductList() {
//   final PageController pageController = PageController(viewportFraction: 1);
//   final int itemsPerPage = 3; // Fixed number of items per page
//   final int totalItems = 20; // Total number of products
//   final int totalPages = (totalItems / itemsPerPage).ceil();

//   return SizedBox(
//     height: 200,
//     child: Stack(
//       alignment: Alignment.center,
//       children: [
//         PageView.builder(
//           controller: pageController,
//           itemCount: totalPages,
//           itemBuilder: (context, pageIndex) {
//             final startIndex = pageIndex * itemsPerPage;
//             final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);

//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(itemsPerPage, (index) {
//                 final itemIndex = startIndex + index;
//                 if (itemIndex >= totalItems) {
//                   return const SizedBox(
//                       width: 100); // Empty space for missing items
//                 }

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[300],
//                         ),
//                         child: const Center(
//                           child: Text("Image"),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Product $itemIndex",
//                         style: const TextStyle(
//                             fontSize: 12, fontWeight: FontWeight.bold),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "R ${(100 + itemIndex * 10).toString()}",
//                         style: const TextStyle(
//                             fontSize: 12, color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             );
//           },
//         ),
//         // Left arrow
//         Positioned(
//           left: 0,
//           child: IconButton(
//             onPressed: () {
//               if (pageController.page! > 0) {
//                 pageController.previousPage(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                 );
//               }
//             },
//             icon: const Icon(Icons.arrow_back_ios, size: 24),
//           ),
//         ),
//         // Right arrow
//         Positioned(
//           right: 0,
//           child: IconButton(
//             onPressed: () {
//               if (pageController.page! < totalPages - 1) {
//                 pageController.nextPage(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                 );
//               }
//             },
//             icon: const Icon(Icons.arrow_forward_ios, size: 24),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget buildHorizontalProductList() {
//   final PageController pageController = PageController(viewportFraction: 1);
//   final int itemsPerPage = 3; // Number of items per page
//   final int totalItems = 20; // Total number of products
//   final int totalPages = (totalItems / itemsPerPage).ceil();

//   return LayoutBuilder(
//     builder: (context, constraints) {
//       // Check for small screens
//       final isSmallScreen = constraints.maxWidth < 600;

//       return SizedBox(
//         height: 200,
//         child: Stack(
//           children: [
//             // Product List
//             PageView.builder(
//               controller: pageController,
//               itemCount: totalPages,
//               itemBuilder: (context, pageIndex) {
//                 final startIndex = pageIndex * itemsPerPage;
//                 final endIndex =
//                     (startIndex + itemsPerPage).clamp(0, totalItems);

//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(itemsPerPage, (index) {
//                     final itemIndex = startIndex + index;
//                     if (itemIndex >= totalItems) {
//                       return const SizedBox(
//                           width: 100); // Empty space for missing items
//                     }

//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: double.infinity,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: Colors.grey[300],
//                               ),
//                               child: const Center(
//                                 child: Text("Image"),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               "Product $itemIndex",
//                               style: const TextStyle(
//                                   fontSize: 12, fontWeight: FontWeight.bold),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "R ${(100 + itemIndex * 10).toString()}",
//                               style: const TextStyle(
//                                   fontSize: 12, color: Colors.green),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               },
//             ),

//             // Left Arrow
//             if (!isSmallScreen)
//               Positioned(
//                 left: 0,
//                 top: 60, // Center vertically relative to the images
//                 bottom: 60,
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     onPressed: () {
//                       if (pageController.page! > 0) {
//                         pageController.previousPage(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.easeInOut,
//                         );
//                       }
//                     },
//                     icon:
//                         const Icon(Icons.arrow_back_ios, color: Colors.white),
//                   ),
//                 ),
//               ),

//             // Right Arrow
//             if (!isSmallScreen)
//               Positioned(
//                 right: 0,
//                 top: 50,
//                 bottom: 50, // Center vertically relative to the images
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     onPressed: () {
//                       if (pageController.page! < totalPages - 1) {
//                         pageController.nextPage(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.easeInOut,
//                         );
//                       }
//                     },
//                     icon: const Icon(Icons.arrow_forward_ios,
//                         color: Colors.white),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       );
//     },
//   );
// }
Widget buildHorizontalProductList(String title, {bool isSmallScreen = false}) {
  final PageController pageController = PageController(viewportFraction: 1);
  final int itemsPerPage = 3; // Number of items per page
  final int totalItems = 20; // Total number of products
  final int totalPages = (totalItems / itemsPerPage).ceil();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title Row
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 200,
        child: Stack(
          children: [
            // Product List
            PageView.builder(
              controller: pageController,
              itemCount: totalPages,
              itemBuilder: (context, pageIndex) {
                final startIndex = pageIndex * itemsPerPage;
                final endIndex =
                    (startIndex + itemsPerPage).clamp(0, totalItems);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(itemsPerPage, (index) {
                    final itemIndex = startIndex + index;
                    if (itemIndex >= totalItems) {
                      return const SizedBox(
                          width: 100); // Empty space for missing items
                    }

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[300],
                              ),
                              child: const Center(
                                child: Text("Image"),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Product $itemIndex",
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "R ${(100 + itemIndex * 10).toString()}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),

            // Left Arrow
            if (!isSmallScreen)
              Positioned(
                left: 0,
                top: 50, // Center vertically relative to the images
                bottom: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (pageController.page! > 0) {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
              ),

            // Right Arrow
            if (!isSmallScreen)
              Positioned(
                right: 0,
                top: 50,
                bottom: 50, // Center vertically relative to the images
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (pageController.page! < totalPages - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

void showAddedToCartDialog(
    BuildContext context,
    String productName,
    String productDescription,
    String productImageUrl,
    String buttonText,
    VoidCallback onButtonPressed) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => AddedToCartScreen(
      productName: productName,
      productDescription: productDescription,
      productImageUrl: productImageUrl,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    ),
  );
}
