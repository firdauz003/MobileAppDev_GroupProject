import 'package:flutter/material.dart';

// =package:flutter/material.dart';

// ==========================================================================
// REQUIREMENT #5: "What's in my Fridge?" Meal Finder (Group Project File)
// ==========================================================================

class MealFinderScreen extends StatefulWidget {
  const MealFinderScreen({Key? key}) : super(key: key);

  @override
  State<MealFinderScreen> createState() => _MealFinderScreenState();
}

class _MealFinderScreenState extends State<MealFinderScreen> {
  // ---------------------------------------------------------
  // 1. THEME & STATE MANAGEMENT
  // ---------------------------------------------------------
  
  // NOTE: Your team must ensure these hex codes match the main Mizan design system.
  final Color primaryColor = const Color(0xFF0F4C3A); // Islamic Green
  final Color accentColor = const Color(0xFFD4AF37); // Mizan Goldaccent
  final Color bgColor = const Color(0xFFF0F4F8); 

  // Controller for custom ingredients text input
  final TextEditingController _ingredientController = TextEditingController();

  // List module of common ingredient options
  final List<String> _availableIngredients = [
    'Chicken', 'Eggs', 'Rice', 'Vegetables', 'Beef', 'Pasta', 'Fish', 
    'Garlic', 'Onion', 'Tomato Sauce', 'Cheese', 'Lemon', 'Butter'
  ];
  
  // Track selected ingredients via interactive multiple checkbox list
  final List<String> _selectedIngredients = [];

  // State to hold and update the matching results List
  Future<List<Map<String, dynamic>>>? _recipesFuture;

  // ---------------------------------------------------------
  // 2. MOCK CLOUD FIRESTORE RECIPE COLLECTION
  // ---------------------------------------------------------
  
  // NOTE: This represents the collection structure for "Shariah-compliant healthy food" in Firestore.
  final List<Map<String, dynamic>> _mockDatabase = [
    {
      'title': 'Grilled Chicken & Veggie Bowl',
      'prepTime_min': 25,
      'calories': 420,
      'tags': ['Chicken', 'Vegetables', 'Rice', 'Garlic'], 
      'fullIngredients': ['1 Large Chicken Breast', '1 cup Jasmine Rice', 'Mixed Vegetables', 'Olive Oil', 'Halal Seasonings'],
      'instructions': ['Cook rice.', 'Season and grill chicken breast.', 'Steam vegetables.', 'Mix together in a bowl and drizzle with olive oil.']
    },
    {
      'title': 'Spicy Beef Pasta',
      'prepTime_min': 30,
      'calories': 580,
      'tags': ['Beef', 'Pasta', 'Tomato Sauce', 'Garlic', 'Onion'],
      'fullIngredients': ['250g Minced Beef (Halal)', '200g Pasta', '1 cup Tomato Paste/Sauce', '1 small Yellow Onion', 'Garlic cloves', 'Chili Flakes'],
      'instructions': ['Boil pasta al dente.', 'Brown the minced beef with garlic and onion.', 'Stir in tomato sauce and chili flakes. Simmer.', 'Combine pasta and meat sauce.']
    },
    {
      'title': 'Classic Egg Fried Rice',
      'prepTime_min': 15,
      'calories': 350,
      'tags': ['Eggs', 'Rice', 'Vegetables', 'Garlic', 'Onion'],
      'fullIngredients': ['3 Large Eggs', '2 cups Cold Rice', '1/2 cup Mixed Frozen Veggies', 'Minced Garlic', '2 tbsp Soy Sauce', 'Sesame Oil'],
      'instructions': ['Scramble eggs quickly and set aside.', 'Sauté garlic and vegetables.', 'Add rice and stir-fry. Break up clumps.', 'Mix in eggs, soy sauce, and sesame oil. Serve hot.']
    },
    {
      'title': 'Lemon Butter Pan-Seared Fish',
      'prepTime_min': 20,
      'calories': 310,
      'tags': ['Fish', 'Vegetables', 'Lemon', 'Butter'],
      'fullIngredients': ['2 White Fish Fillets', 'Fresh Asparagus bunch', '1 Whole Lemon', 'Unsalted Butter', 'Garlic minced'],
      'instructions': ['Season and sear fish fillets 4 mins per side.', 'Melt butter in pan. Add garlic.', 'Sauté asparagus in the butter sauce.', 'Pour lemon juice over fish and serve.']
    }
  ];

  // ---------------------------------------------------------
  // 3. LOGIC & ALGORITHMS (SIMULATED CLOUD READ)
  // ---------------------------------------------------------
  
  // Requirement: Perform Read operation based on inputs.
  Future<List<Map<String, dynamic>>> _findRecipes() async {
    if (_selectedIngredients.isEmpty) return [];

    // Simulate database network loading delay
    await Future.delayed(const Duration(milliseconds: 700)); 

    List<Map<String, dynamic>> matchedRecipes = [];

    // Check recipe tags (core ingredients) against selected ingredients
    for (var recipe in _mockDatabase) {
      List<String> requiredTags = List<String>.from(recipe['tags']);
      int matchCount = 0;

      for (var req in requiredTags) {
        if (_selectedIngredients.contains(req)) {
          matchCount++;
        }
      }

      // If at least one matching core ingredient, include in results module
      if (matchCount > 0) {
        // Add matchCount for sorting logic
        Map<String, dynamic> recipeWithScore = Map<String, dynamic>.from(recipe);
        recipeWithScore['matchCount'] = matchCount; 
        matchedRecipes.add(recipeWithScore);
      }
    }

    // Sort by best match (highest match count goes to top)
    matchedRecipes.sort((a, b) => b['matchCount'].compareTo(a['matchCount']));
    return matchedRecipes;
  }

  void _addCustomIngredient() {
    String newIngredient = _ingredientController.text.trim();
    if (newIngredient.isNotEmpty) {
      // Basic data sanitization: capitalize first letter
      newIngredient = newIngredient[0].toUpperCase() + newIngredient.substring(1).toLowerCase();
      
      setState(() {
        if (!_availableIngredients.contains(newIngredient)) {
          _availableIngredients.insert(0, newIngredient); // Add to master list
        }
        if (!_selectedIngredients.contains(newIngredient) && _selectedIngredients.length < 10) {
          _selectedIngredients.add(newIngredient); // Automatically select it
        }
      });
      _ingredientController.clear();
      FocusScope.of(context).unfocus(); // Automatically close mobile keyboard
    }
  }

  // ---------------------------------------------------------
  // 4. UI BUILDING (FLUTTER FRAMEWORK)
  // ---------------------------------------------------------
  
  @override
  Widget build(BuildContext context) {
    // GestureDetector/FocusScope required for closing keyboard on mobile tap
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        // keyboarDismissBehavior must be set for clean mobile experience
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Banner (Visually fills screen)
            Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=400&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black.withOpacity(0.4),
                ),
                child: const Center(
                  child: Text(
                    "What's in your fridge?",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            // --- SELECTION MODULE CARD ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.kitchen_rounded, color: accentColor),
                      const SizedBox(width: 8),
                      Text(
                        'AI INGREDIENT CHEF',
                        style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Requirement: user inputs
                  TextField(
                    controller: _ingredientController,
                    onSubmitted: (value) => _addCustomIngredient(),
                    textInputAction: TextInputAction.done, 
                    decoration: InputDecoration(
                      hintText: 'Type an ingredient to add...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      filled: true,
                      fillColor: bgColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle, color: primaryColor),
                        onPressed: _addCustomIngredient,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  const Text(
                    'Or select from common items:',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  
                  // Requirement: checkbox list selection
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _availableIngredients.map((ingredient) {
                      final isSelected = _selectedIngredients.contains(ingredient);
                      return FilterChip(
                        label: Text(ingredient),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        selected: isSelected,
                        selectedColor: primaryColor,
                        backgroundColor: Colors.grey[100],
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isSelected ? primaryColor : Colors.transparent),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              if (_selectedIngredients.length < 10) {
                                _selectedIngredients.add(ingredient);
                              }
                            } else {
                              _selectedIngredients.remove(ingredient);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  
                  // Requirement: Upon submission...
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _recipesFuture = _findRecipes();
                        });
                      },
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text('Find Recipes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- Requirement: RESULTS DISPLAY MODULE ---
            if (_recipesFuture != null)
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: primaryColor));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading recipes.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No matching recipes found. Try adding different ingredients!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ),
                    );
                  }

                  List<Map<String, dynamic>> recipes = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggested Meals (${recipes.length})',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      // Requirement: utilize ListView and Card widgets
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          var recipe = recipes[index];
                          return _buildRecipeCard(context, recipe);
                        },
                      ),
                      const SizedBox(height: 80), // Mobile padding for bottom nav bar
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // Helper widget for matching recipe cards
  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    return InkWell(
      onTap: () {
        // Handle navigation to the isolated details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 15),
        elevation: 0, // boxShadow used instead for design control
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.restaurant, color: accentColor, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['title'] ?? 'Unknown Recipe',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe['prepTime_min']} mins',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 15),
                        Icon(Icons.local_fire_department_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe['calories']} kcal',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. RECIPE DETAIL SCREEN (ISOLATED)
// ==========================================
class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Keep theme consistent within this isolated file
    final Color primaryColor = const Color(0xFF0F4C3A);
    final Color accentColor = const Color(0xFFD4AF37);
    
    // Safety check data conversion
    final List<String> ingredients = List<String>.from(recipe['fullIngredients'] ?? []);
    final List<String> instructions = List<String>.from(recipe['instructions'] ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryColor,
        // Requirement: navigation support for mobile
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Optional Video Placeholder ---
              GestureDetector(
                onTap: () {
                  // Simulate mobile video player interaction
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    builder: (context) => Container(
                      height: 300,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.ondemand_video, size: 60, color: primaryColor),
                          const SizedBox(height: 15),
                          Text(
                            'Playing Video Tutorial for\n${recipe['title']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text('Video player plugin initialization point.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))
                    ]
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Icon(Icons.restaurant, size: 100, color: Colors.grey[800]),
                      ),
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow_rounded, color: primaryColor, size: 40),
                      ),
                      Positioned(
                        top: 15, right: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('WATCH TUTORIAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      recipe['title'] ?? 'Recipe Details',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    const SizedBox(height: 15),
                    
                    // Quick Stats Row
                    Row(
                      children: [
                        _buildStatBadge(Icons.timer, '${recipe['prepTime_min']} mins', accentColor),
                        const SizedBox(width: 15),
                        _buildStatBadge(Icons.local_fire_department, '${recipe['calories']} kcal', Colors.orange),
                      ],
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(thickness: 1.5),
                    ),
                    
                    // --- Requirement: Shariah-compliant food cooking instructions ---
                    Row(
                      children: [
                        Icon(Icons.shopping_basket, color: primaryColor),
                        const SizedBox(width: 8),
                        const Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ...ingredients.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8, height: 8,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 15),
                          Expanded(child: Text(item, style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    )).toList(),

                    const SizedBox(height: 30),
                    
                    // Instructions Section
                    Row(
                      children: [
                        Icon(Icons.format_list_numbered, color: primaryColor),
                        const SizedBox(width: 8),
                        const Text('Preparation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ...instructions.asMap().entries.map((entry) {
                      int stepNumber = entry.key + 1;
                      String stepText = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30, height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$stepNumber',
                                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                stepText,
                                style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for stat icons within the details screen
  Widget _buildStatBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
