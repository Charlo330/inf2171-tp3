# Test t04.s - Test de la routine printLignePere avec structure statique

.text

    # Test 1: Lignée paternelle du grand-père
    la a0, grand_pere
    jal printLignePere
    # Sortie attendue: "1950 " suivi d'un newline

    # Test 2: Lignée paternelle du père
    la a0, pere
    jal printLignePere
    # Sortie attendue: "1975 1950 " suivi d'un newline

    # Test 3: Lignée paternelle de la mère
    la a0, mere
    jal printLignePere
    # Sortie attendue: "1978 " suivi d'un newline

    # Test 4: Lignée paternelle de l'enfant1
    la a0, enfant1
    jal printLignePere
    # Sortie attendue: "2000 1975 1950 " suivi d'un newline

    # Test 5: Lignée paternelle de l'enfant2
    la a0, enfant2
    jal printLignePere
    # Sortie attendue: "2005 1975 1950 " suivi d'un newline

    # Test 6: Test avec paramètre NULL
    li a0, 0
    jal printLignePere
    # Sortie attendue: rien (fonction doit gérer NULL proprement)

    # Fin du programme
    li a7, 10                   # Exit
    ecall

#==============================================================================
# Structure familiale
#==============================================================================

.data

grand_pere:
    .dword 0                   # père = 0 (pas de père identifié)
    .dword 0                   # mère = 0 (pas de mère identifiée)
    .dword 1950                # année de naissance
    .dword liste_enfants_gp    # adresse liste des enfants

pere:
    .dword grand_pere          # père = grand_pere
    .dword 0                   # mère = 0 (pas de mère identifiée)
    .dword 1975                # année de naissance
    .dword liste_enfants_pere  # adresse liste des enfants

mere:
    .dword 0                   # père = 0 (pas de père identifié)
    .dword 0                   # mère = 0 (pas de mère identifiée)
    .dword 1978                # année de naissance
    .dword liste_enfants_mere  # adresse liste des enfants

enfant1:
    .dword pere                # père = pere
    .dword mere                # mère = mere
    .dword 2000                # année de naissance
    .dword 0                   # pas d'enfants

enfant2:
    .dword pere                # père = pere
    .dword mere                # mère = mere
    .dword 2005                # année de naissance
    .dword 0                   # pas d'enfants

# Liste des enfants du grand-père (contient seulement le père)
liste_enfants_gp:
    .dword pere                # adresse du nœud enfant
    .dword 0                   # suivant = 0 (dernier élément)
    .dword 0                   # précédent = 0 (premier élément)

# Liste des enfants du père (contient enfant1 et enfant2)
liste_enfants_pere:
    .dword enfant1             # adresse du nœud enfant
    .dword noeud_pere_enfant2  # suivant = deuxième enfant
    .dword 0                   # précédent = 0 (premier élément)

noeud_pere_enfant2:
    .dword enfant2             # adresse du nœud enfant
    .dword 0                   # suivant = 0 (dernier élément)
    .dword liste_enfants_pere  # précédent = premier enfant

# Liste des enfants de la mère (contient enfant1 et enfant2)
liste_enfants_mere:
    .dword enfant1             # adresse du nœud enfant
    .dword noeud_mere_enfant2  # suivant = deuxième enfant
    .dword 0                   # précédent = 0 (premier élément)

noeud_mere_enfant2:
    .dword enfant2             # adresse du nœud enfant
    .dword 0                   # suivant = 0 (dernier élément)
    .dword liste_enfants_mere  # précédent = premier enfant

#stdout:1950 \n1975 1950 \n1978 \n2000 1975 1950 \n2005 1975 1950
