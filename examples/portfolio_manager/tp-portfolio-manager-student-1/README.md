[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/9DJeW4Fo)
# Exercice : Gestionnaire de Portefeuille d'Actions (Tests Unitaires + TDD + Mocking)

## Objectif

Évaluer votre capacité à écrire des tests unitaires, à suivre l'approche TDD (Test-Driven Development) et à mocker les dépendances pour isoler la classe en cours de test.

Pour ce faire, nous allons créer un gestionnaire de portefeuille d'actions qui permet aux utilisateurs d'ajouter, de supprimer et de visualiser des actions dans leur portefeuille, ainsi que de calculer la valeur des actions individuelles qu'ils détiennent et la valeur totale de leur portefeuille.

## Instructions

1. **Aperçu :**

   Vous disposez de :

   - le code initial de la classe `StockPortfolio`, qui est responsable de la gestion d'un portefeuille d'actions.
   - le code initial de la classe `StockPortfolioTest`, dans laquelle vous implémenterez les tests.
   - les interfaces `StockAPI` et `StockStorage`, que vous devrez mocker dans vos tests.

2. **Exigences :**

   - Ecrivez les tests pour la classe `StockPortfolio` et implémentez celle-ci étape par étape, en suivant l'approche TDD.
   - Suivez le fichier de test fourni `StockPortfolioTest` et complétez les méthodes de test selon les scénarios décrits.
   - **Important : à chaque fois que vous implémentez un test, vous DEVEZ le valider avant de commencer votre implémentation de code, puis faire un autre commit une fois le test validé. _Il est acceptable de faire des commits supplémentaires pour corriger le test en cas d'erreur initiale._**

3. **Scénarios à tester :**

   - `addStockQuantity`:
     - ajout d'une quantité d'actions pour une action non détenue.
     - ajout d'une quantité d'actions pour une action déjà détenue.
     - tentative d'ajout d'une quantité d'actions négative.
   - `removeStockQuantity`:
     - suppression d'une quantité d'actions pour une action déjà détenue.
     - tentative de suppression d'une quantité d'actions négative.
     - tentative de suppression d'une quantité d'actions trop importante.
     - tentative de suppression d'une quantité d'actions pour une action non détenue.
   - `getStockPortfolioValue`:
     - calcul de la valeur dans le portefeuille d'une action existante.
     - calcul de la valeur dans le portefeuille d'une action non détenue.
     - tentative de calcul de la valeur dans le portefeuille d'une action non existante.
   - `getTotalPortfolioValue`:
     - calcul de la valeur du portefeuille pour un portefeuille vide.
     - calcul de la valeur du portefeuille pour un portefeuille non vide.
     - calcul de la valeur du portefeuille avec des actions d'une quantité zéro.

## Approche TDD (rappel)

1. Écrire un test qui échoue.
2. Implémenter le code le plus simple pour faire passer le test qui échoue.
3. Refactoriser le code si nécessaire.
4. Répéter ces étapes jusqu'à ce que chaque test soit écrit et passe.

## Spécifications de la Classe StockPortfolio

### Objectif

La classe `StockPortfolio` est responsable de la gestion d'un portefeuille d'actions, y compris des opérations telles que l'ajout ou la suppression d'une quantités d'actions, le calcul de la valeur des actions individuelles et la détermination de la valeur totale de l'ensemble du portefeuille.

### Méthodes

1. `addStockQuantity(symbol: String, quantityToAdd: int): void`

   - **Objectif :** Ajoute la quantité spécifiée d'actions avec le symbole donné au portefeuille.
   - **Paramètres :**
     - `symbol` : Le symbole de l'action à ajouter.
     - `quantityToAdd` : La quantité d'actions à ajouter (doit être un entier positif).
   - **Comportement :**
     - Lève une `IllegalArgumentException` si `quantityToAdd` est négatif.
     - Récupère la quantité actuelle de l'action spécifiée depuis le `stockStorage`.
     - Ajoute `quantityToAdd` à la quantité actuelle.
     - Met à jour la quantité d'actions dans le `stockStorage`.

2. `removeStockQuantity(symbol: String, quantityToRemove: int): void`

   - **Objectif :** Supprime la quantité spécifiée d'actions avec le symbole donné du portefeuille.
   - **Paramètres :**
     - `symbol` : Le symbole de l'action à supprimer.
     - `quantityToRemove` : La quantité d'actions à supprimer (doit être un entier positif).
   - **Comportement :**
     - Lève une `IllegalArgumentException` si `quantityToRemove` est négatif.
     - Récupère la quantité actuelle de l'action spécifiée depuis le `stockStorage`.
     - Soustrait `quantityToRemove` de la quantité actuelle.
     - Lève une `NotEnoughStockQuantityException` si la quantité résultante est négative.
     - Met à jour la quantité d'actions dans le `stockStorage`.

3. `getStockPortfolioValue(symbol: String): double`

   - **Objectif :** Calcule la valeur de l'action spécifiée dans le portefeuille.
   - **Paramètres :**
     - `symbol` : Le symbole de l'action dont la valeur doit être calculée.
   - **Retourne :** La valeur totale de l'action spécifiée en fonction de sa quantité et de son prix actuel.
   - **Comportement :**
     - Récupère la quantité actuelle de l'action spécifiée depuis le `stockStorage`.
     - Récupère le prix actuel de l'action spécifiée depuis le `stockAPI`.
     - Multiplie la quantité par le prix pour calculer la valeur totale.

4. `getTotalPortfolioValue(): double`
   - **Objectif :** Calcule la valeur totale de l'ensemble du portefeuille.
   - **Retourne :** La valeur totale du portefeuille, qui est la somme des valeurs de toutes les actions dans le portefeuille.
   - **Comportement :**
     - Récupère la liste des symboles de toutes les actions dans le portefeuille depuis le `stockStorage`.
     - Parcourt chaque symbole, calcule la valeur de chaque action en utilisant la méthode `getStockPortfolioValue` et renvoie la valeur totale.

### Exceptions

- `IllegalArgumentException` : Lancée lorsqu'un argument invalide est fourni (par exemple, une quantité négative).
- `NotEnoughStockQuantityException` : Lancée lorsqu'une tentative est faite pour supprimer plus d'actions que celles actuellement détenues dans le portefeuille.

### Dépendances

- `StockAPI` : Une interface pour récupérer les prix des actions.
- `StockStorage` : Une interface pour stocker et gérer la quantité d'actions dans le portefeuille.
