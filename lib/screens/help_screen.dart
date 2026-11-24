import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../app/theme.dart';

/// Mode d'emploi : présentation de l'application et de ses fonctionnalités.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<({String title, String text})> _items = [
    (
      title: '1 · Bienvenue',
      text: 'jQuery AJAX Lab vous fait découvrir le Web, HTML, JavaScript, '
          'jQuery, le DOM, les événements, les animations, AJAX, HTTP, JSON '
          'et les API REST. Aucune connaissance préalable n\'est requise.'
    ),
    (
      title: '2 · L\'accueil',
      text: 'L\'écran d\'accueil résume votre progression, reprend la dernière '
          'leçon consultée et donne un accès rapide au cours, au lab et à '
          'l\'explorateur AJAX.'
    ),
    (
      title: '3 · L\'onglet Cours',
      text: 'Le cours est découpé en modules, eux-mêmes découpés en leçons. '
          'Suivez les leçons dans l\'ordre : à partir du module 2, chacun propose des '
          'exercices.'
    ),
    (
      title: '4 · Terminer une leçon',
      text: 'En bas de chaque leçon, touchez « Terminer cette leçon » pour la '
          'marquer comme terminée. Votre progression est enregistrée '
          'automatiquement.'
    ),
    (
      title: '5 · L\'onglet Lab',
      text: 'Le Laboratoire contient des éditeurs HTML, CSS et JavaScript '
          '(avec jQuery). Touchez « Exécuter » pour voir le résultat dans '
          'l\'aperçu et les messages dans la console.'
    ),
    (
      title: '6 · La console',
      text: 'Chaque console.log() de votre code apparaît dans la console du '
          'lab. Les erreurs JavaScript y sont aussi affichées en rouge.'
    ),
    (
      title: '7 · Les exercices',
      text: 'Trois niveaux : GUIDÉ, SEMI-GUIDÉ et AUTONOME. Tapez votre '
          'réponse puis validez-la. En cas d\'erreur, utilisez les indices '
          '(Indice 1, puis Indice 2) ou consultez la solution.'
    ),
    (
      title: '8 · Tester dans le Lab',
      text: 'Depuis un exercice de code, touchez « Tester dans le Lab » : '
          'votre code est copié dans l\'éditeur JavaScript pour que vous '
          'puissiez l\'exécuter immédiatement.'
    ),
    (
      title: '9 · L\'onglet Projets',
      text: 'Dix mini-projets progressifs puis un projet final (AJAX '
          'Dashboard). Chaque projet décompose le travail en étapes avec des '
          'solutions à la clé.'
    ),
    (
      title: '10 · Exécuter un projet',
      text: 'Chaque projet propose « Exécuter le code final dans le Lab » : '
          'le code final est chargé dans le lab et vous pouvez le tester '
          'immédiatement.'
    ),
    (
      title: '11 · Explique-moi ce code',
      text: 'Sur tout bloc de code du cours, touchez l\'icône d\'explication '
          'pour afficher une explication ligne par ligne du code.'
    ),
    (
      title: '12 · L\'onglet Docs',
      text: 'L\'aide-mémoire regroupe les fiches essentielles (sélection, '
          'manipulation, événements, animations, AJAX…) et le glossaire des '
          'termes techniques.'
    ),
    (
      title: '13 · La recherche',
      text: 'Touchez l\'icône loupe pour chercher dans les cours, leçons, '
          'exercices, projets, fiches et le glossaire.'
    ),
    (
      title: '14 · Les favoris',
      text: 'Touchez l\'étoile d\'une leçon, d\'un exercice, d\'un projet ou '
          'd\'une fiche pour l\'ajouter à vos favoris, accessibles depuis '
          'l\'icône étoile de la barre supérieure.'
    ),
    (
      title: '15 · L\'explorateur AJAX',
      text: 'Un mini-Postman pour lancer de vraies requêtes HTTP (GET, POST, '
          'PUT, PATCH, DELETE) sur une URL et visualiser le statut, les '
          'en-têtes et la réponse JSON.'
    ),
    (
      title: '16 · Les exemples rapides',
      text: 'L\'explorateur propose des exemples prêts à l\'emploi : GET '
          'users, POST, PATCH, DELETE, URL invalide ou page 404.'
    ),
    (
      title: '17 · L\'écran Progression',
      text: 'Visible depuis l\'accueil, il détaille votre avancement par '
          'catégorie : bases du Web, jQuery, DOM, Événements, Animations, '
          'AJAX et REST.'
    ),
    (
      title: '18 · Les paramètres',
      text: 'Changez le thème (clair / sombre / système), la taille du texte '
          'et celle du code. La réinitialisation totale se trouve aussi ici.'
    ),
    (
      title: '19 · Aucune connexion requise',
      text: 'Tout le contenu est hors-ligne. Seules les requêtes de '
          'l\'explorateur AJAX et les exemples utilisant des API publiques '
          'ont besoin d\'Internet.'
    ),
    (
      title: '20 · Les citations',
      text: 'L\'accueil affiche chaque jour une citation liée au '
          'développement web.'
    ),
    (
      title: '21 · Progression sauvegardée',
      text: 'Votre progression, vos favoris et vos réglages sont conservés '
          'localement sur l\'appareil, même après fermeture de l\'application.'
    ),
    (
      title: '22 · Par où commencer ?',
      text: 'Le plus simple : Module 1 du cours. Ensuite alternez cours, '
          'exercices et projets. Le lab est là pour expérimenter à tout '
          'moment.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mode d\'emploi')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final item = _items[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              leading: CircleAvatar(
                backgroundColor: LabColors.sky.withValues(alpha: 0.14),
                child: Text('${i + 1}',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: LabColors.sky.readable(context))),
              ),
              title: Text(item.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(item.text, style: const TextStyle(height: 1.5)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
