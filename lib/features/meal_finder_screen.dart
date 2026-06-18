import 'package:flutter/material.dart';

// ==========================================================================
// FEATURE 5: "What's in my Fridge?" Meal Finder 
// This file contains both the Search Screen and the Detail Screen.
// ==========================================================================

class MealFinderScreen extends StatefulWidget {
  const MealFinderScreen({Key? key}) : super(key: key);

  @override
  State<MealFinderScreen> createState() => _MealFinderScreenState();
}

class _MealFinderScreenState extends State<MealFinderScreen> {
  // Theme Colors (Adapted to blend with the Main.dart Teal theme)
  final Color primaryColor = Colors.teal; 
  final Color accentColor = const Color(0xFFD4AF37); // Gold accent
  final Color bgColor = const Color(0xFFF7F9F6); // Matches Scaffold background in main.dart

  final TextEditingController _ingredientController = TextEditingController();

  final List<String> _availableIngredients = [
    'Chicken', 'Eggs', 'Rice', 'Vegetables', 'Beef', 'Pasta', 'Fish', 
    'Garlic', 'Onion', 'Tomato Sauce', 'Cheese', 'Lemon', 'Butter'
  ];
  final List<String> _selectedIngredients = [];

  Future<List<Map<String, dynamic>>>? _recipesFuture;

  // --- MOCK DATABASE (Shariah-compliant healthy food) ---
  final List<Map<String, dynamic>> _mockDatabase = [
    {
      'title': 'Grilled Chicken & Veggie Bowl',
      'prepTime_min': 25,
      'calories': 420,
      'tags': ['Chicken', 'Vegetables', 'Rice', 'Garlic'], 
      'fullIngredients': ['1 Large Chicken Breast', '1 cup Jasmine Rice', 'Mixed Vegetables', '1 tbsp Olive Oil', 'Salt & Pepper'],
      'instructions': ['Cook rice according to package instructions.', 'Grill chicken in a pan over medium heat until fully cooked.', 'Steam the mixed vegetables.', 'Combine all ingredients in a bowl and serve warm.']
    },
    {
      'title': 'Spicy Beef Pasta',
      'prepTime_min': 30,
      'calories': 580,
      'tags': ['Beef', 'Pasta', 'Tomato Sauce', 'Garlic', 'Onion', 'Cheese'],
      'fullIngredients': ['250g Minced Beef (Halal)', '200g Pasta', '1/2 cup Tomato Sauce', '1 small Yellow Onion', 'Garlic cloves', 'Chili Flakes'],
      'instructions': ['Boil pasta in salted water until al dente.', 'Brown the minced beef with garlic and onion in a large skillet.', 'Stir in the tomato sauce and let it simmer for 5 minutes.', 'Combine the meat sauce with the drained pasta.']
    },
    {
      'title': 'Classic Egg Fried Rice',
      'prepTime_min': 15,
      'calories': 300,
      'tags': ['Eggs', 'Rice', 'Vegetables', 'Garlic', 'Onion'],
      'fullIngredients': ['3 Large Eggs', '2 cups Cold Leftover Rice', '1/2 cup Frozen Peas & Carrots', '2 tbsp Soy Sauce', 'Sesame Oil'],
      'instructions': ['Scramble eggs in a heated wok or large pan and set aside.', 'Sauté garlic and vegetables.', 'Add the cold rice and stir continuously over high heat.', 'Mix the eggs back in and drizzle with soy sauce. Serve hot.']
    },
    {
      'title': 'Pan-Seared Lemon Butter Fish',
      'prepTime_min': 20,
      'calories': 310,
      'tags': ['Fish', 'Vegetables', 'Lemon', 'Butter', 'Garlic'],
      'fullIngredients': ['2 White Fish Fillets', 'Bunch of Fresh Asparagus', '1 Whole Lemon', 'Unsalted Butter', 'Garlic cloves'],
      'instructions': ['Melt butter in a pan over medium-high heat.', 'Sear the fish fillet for about 4 minutes per side.', 'Toss the asparagus in the same pan until tender-crisp.', 'Serve together with a squeeze of fresh lemon juice.']
    }
  ];

  // --- MATCHING ALGORITHM (No missing ingredient logic) ---
  Future<List<Map<String, dynamic>>> _findRecipes() async {
    if (_selectedIngredients.isEmpty) return [];

    await Future.delayed(const Duration(milliseconds: 800)); 

    List<Map<String, dynamic>> matchedRecipes = [];

    for (var recipe in _mockDatabase) {
      List<String> recipeTags = List<String>.from(recipe['tags']);
      int matchCount = 0;

      for (var selected in _selectedIngredients) {
        if (recipeTags.contains(selected)) {
          matchCount++;
        }
      }

      // If it has at least one matching ingredient, show it
      if (matchCount > 0) {
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
      newIngredient = newIngredient[0].toUpperCase() + newIngredient.substring(1).toLowerCase();
      
      setState(() {
        if (!_availableIngredients.contains(newIngredient)) {
          _availableIngredients.insert(0, newIngredient); 
        }
        if (!_selectedIngredients.contains(newIngredient) && _selectedIngredients.length < 10) {
          _selectedIngredients.add(newIngredient);
        }
      });
      _ingredientController.clear();
      FocusScope.of(context).unfocus(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    // Note: No AppBar here because main.dart UniversalNavigationHub already has one!
    return Scaffold(
      backgroundColor: bgColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Hero Banner
              Container(
                height: 120,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=400&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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

              // AI CHEF SELECTION CARD
              Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.kitchen_rounded, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'AI INGREDIENT CHEF',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
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
                            backgroundColor: Colors.grey[200],
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
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
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
              ),

              const SizedBox(height: 25),

              // RESULTS SECTION
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            var recipe = recipes[index];
                            return _buildRecipeCard(context, recipe);
                          },
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    return InkWell(
      onTap: () {
        // Pushes the details screen over the entire app
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
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
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
                child: Icon(Icons.restaurant, color: primaryColor, size: 30),
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
// RECIPE DETAIL SCREEN (Inside the same file)
// ==========================================
class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.teal;
    final Color accentColor = const Color(0xFFD4AF37);
    
    final List<String> ingredients = List<String>.from(recipe['fullIngredients'] ?? []);
    final List<String> instructions = List<String>.from(recipe['instructions'] ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text("Recipe Details", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- VIDEO PLAYER PLACEHOLDER ---
              GestureDetector(
                onTap: () {
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
                  margin: const EdgeInsets.all(20),
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['title'] ?? 'Recipe Details',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    const SizedBox(height: 15),
                    
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
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
