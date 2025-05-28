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
    //Gemini gemini = Gemini();
    // GenerativeModel model = gemini.model;

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
    print('*****${response.text?.trim()}********');
    return response.text?.trim() ?? '{"Error": "Nessuna risposta dal modello"}';
  }
}
