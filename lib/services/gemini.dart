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
    print('*****${response.text?.trim()}********');
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

    print('INGREDINTI DISPONIBILI: *$ingredients**');

    var prompt =
        '''Sei uno barman esperto di alcolici che ha viaggiato per il mondo e che conosce tutti i coktail tipici di ogni paese.\n
            ora gestisci un bar con clienti molto esigenti, devi rispettare esattamente le richieste dei clienti.
            Voglio che tu suggerisca un cocktail da preparare, nello specifico devi creare un $category, controlla quindi che il coktail rispetta esattamente tale categoria\n\n
            gli ingredienti che hai a disposizione sono i seguenti: $ingredients, non devi usare altri ingredienti oltre quelli a disposizione, se hai a disposizione un ingrediente non puoi usare una sua variante, ad esempio se hai a disposizione acqua non puoi usare acqua frizzante.
            La prima cosa che devi fare è controllare che gli ingredienti che ho a disposizione sono sufficienti per la preparazione, se non ho ingredienti o se non sono sufficienti\n
            segnalalo con un messaggio di errore specificano che gli ingredienti non sono sufficienti all' interno del campo Error, e non generarmi un cocktail e restituiscimi null per il resto delle informazioni.\n\n
            
            Altrimenti, solo se i miei ingredienti sono sufficienti, Voglio che tu mi dia il titolo di un coktail , gli ingredienti e la ricetta per la reparazione del cocktail. Se hai trovato aleno un'errore nei dati allora descrivimi l'errore, altrimenti
            imposta l'errore a null''';

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
    print('INGREDINTI DISPONIBILI: *$ingredients**');

    var prompt =
        '''Sei uno barman esperto di alcolici che ha viaggiato per il mondo e che conosce tutti i coktail tipici di ogni paese.\n
            ora gestisci un bar con clienti molto esigenti, devi rispettare esattamente le richieste dei clienti.
            Voglio che tu suggerisca un cocktail da preparare, nello specifico devi creare un $category, controlla quindi che il coktail rispetta esattamente tale categoria.\n\n
            hai già preparato i seguenti coktail: $oldCocktails.
            gli ingredienti che hai a disposizione sono i seguenti: $ingredients, non devi usare altri ingredienti oltre quelli a disposizione, se hai a disposizione un ingrediente non puoi usare una sua variante, ad esempio se hai a disposizione acqua non puoi usare acqua frizzante.
            La prima cosa che devi fare è controllare che gli ingredienti che ho a disposizione sono sufficienti per la preparazione di un coktail diverso da quelli che hai già preparato, se gli ingredienti non sono sufficienti per la preparazione di un nuovo coktail\n
            segnalalo con un messaggio di errore specificano che gli ingredienti non sono sufficienti all' interno del campo Error, e non generarmi un cocktail e restituiscimi null per il resto delle informazioni.\n\n
            
            Altrimenti, solo se i miei ingredienti sono sufficienti per la preparazione di un coktail diverso dai precedenti,, Voglio che tu mi dia il titolo di un coktail , gli ingredienti con i rispettivi url delle foto e la ricetta per la reparazione del cocktail. Se hai trovato aleno un'errore nei dati allora descrivimi l'errore, altrimenti
            imposta l'errore a null''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response;
  }
}
