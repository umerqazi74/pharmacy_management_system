import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoyaltyProgramPage extends StatefulWidget {
  const LoyaltyProgramPage({super.key});

  @override
  State<LoyaltyProgramPage> createState() => _LoyaltyProgramPageState();
}

class _LoyaltyProgramPageState extends State<LoyaltyProgramPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<LoyaltyMember> _members = [];
  final List<LoyaltyReward> _rewards = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _selectedTabIndex = 0;
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterMembers);
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate API calls
      await Future.delayed(const Duration(seconds: 1));

      // Sample data - replace with actual database calls
      setState(() {
        _members.addAll([
          LoyaltyMember(
            id: 'C-1001',
            name: 'John Smith',
            points: 1250,
            joinDate: DateTime.now().subtract(const Duration(days: 365)),
            lastActivity: DateTime.now().subtract(const Duration(days: 7)),
            tier: 'Gold',
          ),
          LoyaltyMember(
            id: 'C-1002',
            name: 'Sarah Johnson',
            points: 750,
            joinDate: DateTime.now().subtract(const Duration(days: 180)),
            lastActivity: DateTime.now().subtract(const Duration(days: 30)),
            tier: 'Silver',
          ),
          LoyaltyMember(
            id: 'C-1003',
            name: 'Robert Chen',
            points: 320,
            joinDate: DateTime.now().subtract(const Duration(days: 90)),
            lastActivity: DateTime.now().subtract(const Duration(days: 120)),
            tier: 'Bronze',
          ),
        ]);

        _rewards.addAll([
          LoyaltyReward(
            id: 'R-1001',
            name: '\$5 Discount',
            pointCost: 500,
            description: 'Redeem for \$5 off your next purchase',
            isActive: true,
          ),
          LoyaltyReward(
            id: 'R-1002',
            name: 'Free Vitamin Bottle',
            pointCost: 1000,
            description: 'Get a free bottle of Vitamin C 1000mg',
            isActive: true,
          ),
          LoyaltyReward(
            id: 'R-1003',
            name: '20% Off Entire Purchase',
            pointCost: 1500,
            description: '20% discount on your entire order',
            isActive: false,
          ),
        ]);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // In a real app, this would filter the actual member list
      // For now we're just using the sample data directly
    });
  }

  void _showMemberDetails(LoyaltyMember member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(member.tier),
                  backgroundColor: _getTierColor(member.tier),
                ),
              ],
            ),
            const Divider(),
            _buildDetailRow('Member ID:', member.id),
            _buildDetailRow('Points:', member.points.toString()),
            _buildDetailRow('Member Since:', DateFormat.yMMMMd().format(member.joinDate)),
            _buildDetailRow('Last Activity:', DateFormat.yMMMMd().format(member.lastActivity)),
            const SizedBox(height: 16),
            const Text(
              'Available Rewards',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ..._rewards.where((r) => r.isActive).map((reward) => ListTile(
              leading: Icon(
                Icons.card_giftcard,
                color: member.points >= reward.pointCost ? Colors.green : Colors.grey,
              ),
              title: Text(reward.name),
              subtitle: Text(reward.description),
              trailing: Text(
                '${reward.pointCost} pts',
                style: TextStyle(
                  color: member.points >= reward.pointCost ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: member.points >= reward.pointCost
                  ? () => _redeemReward(member, reward)
                  : null,
            )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _addPoints(member),
                child: const Text('Add Points'),
              ),
            ),
             SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'gold':
        return Colors.amber[300]!;
      case 'silver':
        return Colors.grey[300]!;
      case 'bronze':
        return Colors.brown[300]!;
      default:
        return Colors.blue[100]!;
    }
  }

  void _redeemReward(LoyaltyMember member, LoyaltyReward reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Redemption'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Redeem ${reward.name} for ${reward.pointCost} points?'),
            const SizedBox(height: 8),
            Text('Member: ${member.name} (${member.points} pts)'),
            const SizedBox(height: 16),
            Text('After redemption: ${member.points - reward.pointCost} pts remaining'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context); // Close confirmation
              Navigator.pop(context); // Close member details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${reward.name} redeemed for ${member.name}'),
                  backgroundColor: Colors.green,
                ),
              );
              // In real app: Update member's points via API
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addPoints(LoyaltyMember member) {
    Navigator.pop(context); // Close member details
    // Implement points addition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add points to ${member.name}\'s account (implementation needed)')),
    );
  }

  void _editReward(LoyaltyReward reward) {
    // Implement reward editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${reward.name} reward (implementation needed)')),
    );
  }

  void _toggleRewardStatus(LoyaltyReward reward) {
    setState(() {
      reward.isActive = !reward.isActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${reward.name} ${reward.isActive ? 'activated' : 'deactivated'}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Loyalty Program'),
          bottom: TabBar(
            onTap: (index) => setState(() => _selectedTabIndex = index),
            tabs: const [
              Tab(icon: Icon(Icons.people), text: 'Members'),
              Tab(icon: Icon(Icons.card_giftcard), text: 'Rewards'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search and Filter
              if (_selectedTabIndex == 0)
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search members...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _selectedTabIndex == 0
                    ? _buildMembersTab()
                    : _buildRewardsTab(),
              ),
            ],
          ),
        ),
        floatingActionButton: _selectedTabIndex == 1
            ? FloatingActionButton(
          onPressed: () => _addNewReward(),
          child: const Icon(Icons.add),
        )
            : null,
      ),
    );
  }

  Widget _buildMembersTab() {
    return _members.isEmpty
        ? const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('No loyalty members found'),
        ],
      ),
    )
        : ListView.builder(
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final member = _members[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getTierColor(member.tier),
              child: Text(member.name[0]),
            ),
            title: Text(member.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${member.points} points'),
                Text(
                  '${member.tier} Tier',
                  style: TextStyle(color: _getTierColor(member.tier)),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showMemberDetails(member),
          ),
        );
      },
    );
  }

  Widget _buildRewardsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Rewards',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _rewards.isEmpty
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.card_giftcard, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('No rewards configured'),
              ],
            ),
          )
              : ListView.builder(
            itemCount: _rewards.length,
            itemBuilder: (context, index) {
              final reward = _rewards[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    Icons.card_giftcard,
                    color: reward.isActive ? Colors.green : Colors.grey,
                  ),
                  title: Text(reward.name),
                  subtitle: Text(reward.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${reward.pointCost} pts'),
                      IconButton(
                        icon: Icon(
                          reward.isActive
                              ? Icons.toggle_on
                              : Icons.toggle_off,
                          color: reward.isActive ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => _toggleRewardStatus(reward),
                      ),
                    ],
                  ),
                  onTap: () => _editReward(reward),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _addNewReward() {
    // Implement new reward creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new reward (implementation needed)')),
    );
  }
}

class LoyaltyMember {
  final String id;
  final String name;
  int points;
  final DateTime joinDate;
  final DateTime lastActivity;
  final String tier;

  LoyaltyMember({
    required this.id,
    required this.name,
    required this.points,
    required this.joinDate,
    required this.lastActivity,
    required this.tier,
  });
}

class LoyaltyReward {
  final String id;
  final String name;
  final int pointCost;
  final String description;
  bool isActive;

  LoyaltyReward({
    required this.id,
    required this.name,
    required this.pointCost,
    required this.description,
    required this.isActive,
  });
}