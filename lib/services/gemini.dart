import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Gemini {
  static final Gemini _instance = Gemini._internal();

  Gemini._internal();

  factory Gemini() {
    return _instance;
  }

  //final String prompt;
  late GenerativeModel _model;

  Future<void> initGemini() async {
    await dotenv.load(fileName: ".env");

    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      stderr.writeln(r'No $GEMINI_API_KEY environment variable');
      exit(1);
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(temperature: 0.1, maxOutputTokens: 15),
    );
  }

  GenerativeModel get model => _model;

  Future<String> getIngredient(String keywords) async {
    Gemini gemini = Gemini();
    GenerativeModel model = gemini.model;

    var prompt = '''
        Impersonate a cocktail expert. Your task is to analyze the characteristics of an ingredient used in cocktails and tell me which ingredient it is.
        I don't want to know the brand of the ingredient but the type for example: wine, beer....
        you have to distinguish between an ingredient and the juice of that ingredient, for example peach and peach juice.
        The outputs you give me will be the ingredients I will use to create my cocktails.
        These are the keywords related to the ingredient you have to analyze: $keywords

        Respond by describing the type of ingredient, for example:
        - Vodka
        - Gin
        - Rum
        - Dark rum
        - Light rum
        - Tequila
        - Bhisky
        - Triple Sec
        - Vermouth
        - whiskey
        - Campari
        - Fresh Lime Juice
        - Fresh Lemon Juice
        - Orange Juice
        - Pineapple Juice
        - Angostura Bitters
        - Coconut Cream
        - Maraschino Cherry
        - Cherry Liqueur
        - Ginger Beer
        - Orange
        - wine
        - beer
        - water
        - tonic water
        - acqua tonica
        - Mint
        - Lime
        - Sugar
        - Angostura Bitters
        - Bourbon
        - Sugar
        - Swedish punsch
        - Sweet and Sour
        - Sweet Vermouth
        - Tabasco Sauce
        - Tang
        - Tawny port
        - Tea
        - Tennessee whiskey
        - Tequila rose
        - Peach juice

         Simply reply with the name of the ingredient, without any explanation or additional text.
        ''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text?.trim() ?? '{"Error": "Nessuna risposta dal modello"}';
  }

  void updateSchema(Schema newSchema) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: dotenv.env['API_KEY']!,
      generationConfig: GenerationConfig(
        temperature: 1,
        maxOutputTokens: 1000,
        responseMimeType: 'application/json',
        responseSchema: newSchema,
      ),
    );
  }

  Schema _setSchemaCocktail() {
    return Schema(
      SchemaType.object,
      description: "Ricetta da preparare",
      requiredProperties: ["Error", "title", "ingredients", "recipe"],
      properties: {
        "Error": Schema(
          SchemaType.string,
          description: "Descrizione dell'errore",
          nullable: true,
        ),
        "title": Schema(
          SchemaType.string,
          description: "Nome del cocktail.",
          nullable: true,
        ),
        "ingredients": Schema(
          SchemaType.array,
          description: "Lista di ingredienti",
          items: Schema(
            SchemaType.object,
            properties: {
              "name": Schema(
                SchemaType.string,
                description: "Nome dell'ingrediente",
                nullable: true,
              ),
            },
          ),
        ),
        "recipe": Schema(
          SchemaType.string,
          description: "Ricetta per la preparazione del cocktail",
          nullable: true,
        ),
      },
    );
  }

  Future getCocktail(String ingredients, String category) async {
    Gemini gemini = Gemini();
    updateSchema(_setSchemaCocktail());
    GenerativeModel model = gemini.model;

    var prompt =
        '''You are an expert bartender in spirits who has traveled the world and knows every country’s typical cocktails.
            Now you run a bar with very demanding customers, and you must follow the customers’ requests exactly.
            I want you to suggest a cocktail to prepare. Specifically, you must create a $category, so ensure the cocktail matches that category exactly.
            The ingredients you have available are: $ingredients. You must not use any ingredients other than those available. If you have a given ingredient, you may not use its variant—e.g., if you have water, you cannot use sparkling water. Ingredients you don’t have cannot even be used as drink garnishes.
            The first thing you must do is check whether I have sufficient ingredients for the preparation. If I don’t have the ingredients or they are insufficient,
            signal it with an error message specifying that the ingredients are insufficient in the Error field, do not generate a cocktail, and return null for the other fields.
            
            Otherwise, only if my ingredients are sufficient, I want you to give me the title of a cocktail, the list of ingredients, and the recipe for preparing the cocktail. If you find any error in the data, describe the error; otherwise, set Error to null.''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response;
  }

  Future getNewCocktail(
    String ingredients,
    String category,
    var oldCocktails,
  ) async {
    Gemini gemini = Gemini();
    updateSchema(_setSchemaCocktail());
    GenerativeModel model = gemini.model;

    var prompt =
        '''You are an expert spirits bartender with international experience and a deep knowledge of each country’s typical cocktails. You now run a bar with highly demanding customers—their requests must be followed to the letter.
            I’m asking you to suggest a new cocktail to prepare, belonging to the following category: $category. It is essential that the cocktail exactly matches this category.
            
            The following JSON contains the cocktails you have already prepared, each with fields [Error, ingredients, recipe]: $oldCocktails. Within each ingredients array, you will find items like [{"name": "Cola"}, {"name": "Peach Juice"}].
            The ingredients currently available are: $ingredients.

            Rules to follow:
            Use only the available ingredients. You may not use variants (e.g., if you have “water,” you cannot use “sparkling water”).
            Ingredients not available cannot be used—even as decoration.
            If the category is Mocktail, you cannot use any alcoholic ingredients.
            Compare each ingredient of the new cocktail with those already present in each cocktail in $oldCocktails, specifically in their ingredients fields.

            Critical Rule:
            The cocktail you propose must not contain exactly the same combination of ingredients as any previously prepared cocktail.
            The order of ingredients does not matter: two cocktails are considered identical if they have the same ingredients, regardless of order or differing quantities.
            You may reuse one or more ingredients that were used before, but not all together in the same combination as any existing cocktail.

            What to do:
            Check whether it is possible—given the available ingredients—to create a cocktail that:
            Respects the specified category (e.g., if it's a mocktail, it must contain no alcohol), and
            Does not have exactly the same list of ingredients (ignoring order and quantities) as any already existing cocktail.

            If it is not possible:
            Fill the Error field with a clear message explaining that the ingredients are insufficient.
            Return null for all other fields (name, recipe, ingredients).
            If it is possible to prepare a valid and different cocktail, return:
            A brand‑new cocktail suggestion that meets the requested category.

            Provide:
            The cocktail’s name
            The list of ingredients (each including its image URL)
            A detailed recipe for preparation
            If you found any data errors, describe them in the Error field; otherwise, set Error to null.

            Example check:
            If you have already created:
            Cocktail A: {Error: null, ingredients: [{name: Peach Juice}, {name: Cola}], recipe: "…", title: "Peachy Cola"}
            Cocktail B: {Error: null, ingredients: [{name: Cola}, {name: Peach Juice}], recipe: "…", title: "Peachy Cola Remix"}
            You cannot propose a Cocktail C with {Cola, Peach Juice} — even if the recipe, order, or quantities differ. ''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response;
  }
}
