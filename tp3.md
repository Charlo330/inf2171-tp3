---
TP3 Arbre généalogique
---

## Description

Les arbres généalogiques permettent de représenter et de tracer les liens familiaux à travers les générations.

L'objectif de ce TP est de concevoir une bibliothèque de gestion d'arbres généalogiques qui permet de créer, manipuler et interroger des structures familiales représentées sous forme d'arbres.

### Structure généalogique

Pour représenter un arbre généalogique, nous utilisons une structure de données basée sur des nœuds liés qui représentent les personnes et leurs relations familiales.

Chaque nœud personne de la structure fait 32 octets et doit respecter la forme suivante :

* `père` : l'adresse du nœud père, ou 0 s'il n'est pas identifié (8 octets) ;
* `mère` : l'adresse du nœud mère, ou 0 s'il n'est pas identifié (8 octets) ;
* `année` : l'année de naissance de la personne (8 octets) ;
* `enfants` : l'adresse de la liste des enfants, ou 0 s'il n'y en a pas (8 octets) ;
* la structure est alignée à 8 octets.

La liste des enfants est une liste doublement chaînée où chaque nœud fait 24 octets :

* `enfant` : l'adresse du nœud enfant (8 octets) ;
* `suivant` : l'adresse du nœud suivant dans la liste, ou 0 si c'est le dernier (8 octets) ;
* `précédent` : l'adresse du nœud précédent dans la liste, ou 0 si c'est le premier (8 octets).

### Exemple

Voici un exemple d'arbre possible :

```
Grand-père (1950)
  |
Père (1975) ---- Mère (1978)
            /  \
     Enfant1   Enfant2
     (2000)     (2005)
```

Cette représentation correspond à 4 nœuds personnes :
- Grand-père : année=1950, père=0, mère=0, enfants→liste contenant Père
- Père : année=1975, père=Grand-père, mère=0, enfants→liste contenant Enfant1 et Enfant2
- Enfant1 : année=2000, père=Père, mère=0, enfants=0
- Enfant2 : année=2005, père=Père, mère=0, enfants=0

La liste des enfants de Père et Mère contiennent deux nœuds de liste chaînée pointant respectivement vers Enfant1 et Enfant2.

Cette représentation permet de naviguer efficacement dans l'arbre généalogique, que ce soit vers les ascendants (parents) ou les descendants (enfants).

## Bibliothèque de généalogie

Votre travail est de développer une bibliothèque `arbre.s` qui expose des routines pour gérer des arbres généalogiques représentés par la structure décrite ci-dessus.

### Routine `newP`

`newP` crée une nouvelle personne avec allocation dynamique dans le tas.

* `a0`: année de naissance
* `a1`: adresse du père (0 si non identifié)
* `a2`: adresse de la mère (0 si non identifié)
* résultat `a0`: l'adresse du nouveau nœud personne, ou 0 en cas d'erreur d'allocation

La routine alloue 32 octets dans le tas pour le nouveau nœud et initialise tous les champs. La liste des enfants est initialisée à 0.

Note : utilisez l'appel système RARS `Sbrk` pour l'allocation dans le tas.

```asm
	li a0, 1980    # année de naissance
	li a1, 0       # pas de père identifié
	li a2, 0       # pas de mère identifiée
	call newP
	mv s0, a0      # sauvegarde l'adresse de la nouvelle personne
```

Le test `t01.s` permet de tester l'implémentation de `newP`.

### Routine `mGen`

`mGen` détermine le niveau de génération d'une personne dans l'arbre généalogique.

* `a0`: l'adresse du nœud personne
* résultat `a0`: le niveau de génération (nombre d'étages dans l'arbre ascendant)

Le niveau de génération correspond au nombre maximum d'étages remontant vers les ancêtres. Une personne sans parents a un niveau de 1. Une personne avec des parents a un niveau de 1 + max(niveau_père, niveau_mère).

```asm
	mv a0, s0      # adresse de la personne
	call mGen
	# a0 contient le niveau de génération
```


Les tests `t02.s` et `t03.s` permettent de tester l'implémentation de `mGen` avec une structure de données statique (`t02`) et dynamique avec `newP`(`t03`).

### Routine `printLignePere`

`printLignePere` affiche l'année de naissance de chaque membre de la lignée paternelle.

* `a0`: l'adresse du nœud personne (enfant)

La routine parcourt la lignée paternelle en remontant de père en père et affiche l'année de naissance de chaque personne, séparée par des espaces, suivie d'un retour à la ligne. Pour faciliter l'implémentation, il y aura toujours un espace à la fin de la ligne.

```asm
	mv a0, s0      # adresse de la personne de départ
	call printLignePere
	# Affiche par exemple: "2000 1975 1950 " suivi d'un retour à la ligne
```


Les tests `t04.s` et `t05.s` permettent de tester l'implémentation de `printLignePere` avec une structure de données statique (`t04`) et dynamique avec `newP`(`t05`).

### Routine `addEnf`

`addEnf` ajoute un enfant à un parent dans l'arbre généalogique.

* `a0`: l'adresse du nœud enfant
* `a1`: l'adresse du nœud parent
* résultat `a0`: 1 si succès, 0 si erreur

La routine crée un nouveau nœud dans la liste doublement chaînée des enfants du parent. Le nouveau nœud est ajouté à la fin de la liste.

```asm
	mv a0, s1      # adresse de l'enfant
	mv a1, s0      # adresse du parent
	call addEnf
	# a0 contient 1 si succès, 0 si erreur
```

### Routine `sizeArbre`

`sizeArbre` calcule le nombre total de descendants d'une personne.

* `a0`: l'adresse du nœud personne
* résultat `a0`: le nombre total de descendants

La routine compte récursivement tous les enfants, petits-enfants, arrière-petits-enfants, etc. d'une personne donnée.

```asm
	mv a0, s0      # adresse de la personne
	call sizeArbre
	# a0 contient le nombre total de descendants
```

Les tests `t06.s` et `t07.s` permettent de tester l'implémentation de `sizeArbre` et `addEnf` avec une structure de données statique (`t06`) et dynamique avec `newP`(`t07`).

## Réalisation

Développez la bibliothèque `arbre.s` qui doit exporter (avec la directive `.global`) les étiquettes demandées: `newP`, `mGen`, `printLignePere`, `addEnf` et `sizeArbre`.
