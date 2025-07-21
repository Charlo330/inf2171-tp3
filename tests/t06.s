# Test t06.s - Test de la routine sizeArbre avec structure statique

.data
    # Messages pour les tests
    msg_ok: .string "OK\n"
    msg_fail: .string "FAIL\n"

    # Nombres de descendants attendus
    descendants_attendus_grandpere: .dword 3    # Grand-père: père, enfant1, enfant2
    descendants_attendus_pere: .dword 2         # Père: enfant1, enfant2
    descendants_attendus_mere: .dword 2         # Mère: enfant1, enfant2
    descendants_attendus_enfant1: .dword 0      # Enfant1: aucun descendant
    descendants_attendus_enfant2: .dword 0      # Enfant2: aucun descendant

.text

    # Test 1: Nombre de descendants du grand-père
    la a0, grand_pere
    jal sizeArbre
    ld t0, descendants_attendus_grandpere
    bne a0, t0, test_fail

    # Test 2: Nombre de descendants du père
    la a0, pere
    jal sizeArbre
    ld t0, descendants_attendus_pere
    bne a0, t0, test_fail

    # Test 3: Nombre de descendants de la mère
    la a0, mere
    jal sizeArbre
    ld t0, descendants_attendus_mere
    bne a0, t0, test_fail

    # Test 4: Nombre de descendants de l'enfant1
    la a0, enfant1
    jal sizeArbre
    ld t0, descendants_attendus_enfant1
    bne a0, t0, test_fail

    # Test 5: Nombre de descendants de l'enfant2
    la a0, enfant2
    jal sizeArbre
    ld t0, descendants_attendus_enfant2
    bne a0, t0, test_fail

    # Test 6: Test avec paramètre NULL
    li a0, 0
    jal sizeArbre
    bne a0, zero, test_fail     # Doit retourner 0 pour NULL

    # Tous les tests ont réussi
    j test_success

test_success:
    la a0, msg_ok
    li a7, 4                    # PrintString
    ecall
    j exit_program

test_fail:
    la a0, msg_fail
    li a7, 4                    # PrintString
    ecall
    j exit_program

exit_program:
    li a7, 10                   # Exit
    ecall

#==============================================================================
# Structure de données
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

#stdout:OK
