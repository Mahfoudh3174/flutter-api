import 'package:demo/models/medication.dart';
import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/medication/medication_controller.dart';

class MedicationListView extends StatefulWidget {
  const MedicationListView({super.key});

  @override
  State<MedicationListView> createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  final MedicationController medicationController = Get.find();
  late final ScrollController scrollController;
  final double _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    await medicationController.loadMedications();
  }

  void _onScroll() {
    if (!scrollController.hasClients ||
        medicationController.isLoadingMore.value ||
        !medicationController.hasMore.value) {
      return;
    }

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      medicationController.loadMedications(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Medications'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _handleBackPress,
      ),
      actions: [_buildCartButton()],
    );
  }

  void _handleBackPress() {
    if (medicationController.cartItems.isEmpty) {
      Get.offAllNamed(RouteClass.getHomeRoute());
    } else {
      Get.defaultDialog(
        title: 'Confirm Exit',
        content: const Text(
          'Do you want to exit? Your cart items will be lost.',
        ),
        onCancel: () => Get.back(),
        onConfirm: () {
          Get.back();
          Get.offAllNamed(RouteClass.getHomeRoute());
        },
      );
    }
  }

  Widget _buildCartButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Get.toNamed(RouteClass.getCardRoute()),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: Obx(() {
            final count = medicationController.cartItems.length;
            return count > 0 ? _buildCartBadge(count) : const SizedBox.shrink();
          }),
        ),
      ],
    );
  }

  Widget _buildCartBadge(int count) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Obx(() {
        if (medicationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (medicationController.medications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.medication_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text('No medications found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => medicationController.loadMedications(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return _buildMedicationList();
      }),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(Get.context!).colorScheme.primaryContainer.withOpacity(0.3),
          Theme.of(Get.context!).colorScheme.background,
        ],
      ),
    );
  }

  Widget _buildMedicationList() {
    return RefreshIndicator(
      onRefresh: () => medicationController.loadMedications(loadMore: false),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: Obx(() {
                    final meds = medicationController.medications;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => MedicationCard(
                          medication: meds[index],
                          onAddToCart:
                              () => medicationController.addToCart(meds[index]),
                        ),
                        childCount: meds.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio:
                                0.72, // Adjusted to prevent overflow
                          ),
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: Obx(() {
                    return medicationController.isLoadingMore.value
                        ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                        : const SizedBox.shrink();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onAddToCart;
  static const _defaultIcon = Icons.medical_services;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bigger image section (55% of card height)
          Expanded(
            flex: 55,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                ),
              ),
              child: _buildMedicationImage(),
            ),
          ),
          // Content section (30% of card height)
          Expanded(
            flex: 30,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          medication.name ?? 'Unknown Medication',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Price display
                  Text(
                    "${medication.price?.toStringAsFixed(2)} MRU",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add to cart button at bottom (15% of card height)
          Expanded(
            flex: 15,
            child: Container(
              margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 0,
                  ),
                  minimumSize: const Size(0, 32),
                ),
                onPressed: onAddToCart,
                icon: const Icon(Icons.shopping_cart, size: 14),
                label: const Text(
                  'Add',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationImage() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Image.network(
              "http://192.168.100.4:8000/storage/${medication.imageUrl!}",
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Image load error: $error');
          return _buildDefaultIcon();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Center(child: Icon(_defaultIcon, size: 80, color: Colors.blue[300]));
  }
}
