# Test t02.s - Test de la routine mGen

.data
    # Messages pour les tests
    msg_ok: .string "OK\n"
    msg_fail: .string "FAIL\n"

    # Niveaux de génération attendus
    niveau_attendu_grandpere: .dword 1    # Grand-père: pas de parents
    niveau_attendu_pere: .dword 2         # Père: 1 parent (grand-père)
    niveau_attendu_mere: .dword 1         # Mère: pas de parents
    niveau_attendu_enfant1: .dword 3      # Enfant1: 2 parents (père niveau 2, mère niveau 1) -> max(2,1) + 1 = 3
    niveau_attendu_enfant2: .dword 3      # Enfant2: même chose que enfant1

.text

    # Test 1: Niveau de génération du grand-père
    la a0, grand_pere
    jal mGen
    ld t0, niveau_attendu_grandpere
    bne a0, t0, test_fail

    # Test 2: Niveau de génération du père
    la a0, pere
    jal mGen
    ld t0, niveau_attendu_pere
    bne a0, t0, test_fail

    # Test 3: Niveau de génération de la mère
    la a0, mere
    jal mGen
    ld t0, niveau_attendu_mere
    bne a0, t0, test_fail

    # Test 4: Niveau de génération de l'enfant1
    la a0, enfant1
    jal mGen
    ld t0, niveau_attendu_enfant1
    bne a0, t0, test_fail

    # Test 5: Niveau de génération de l'enfant2
    la a0, enfant2
    jal mGen
    ld t0, niveau_attendu_enfant2
    bne a0, t0, test_fail

    # Test 6: Test avec paramètre NULL
    li a0, 0
    jal mGen
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

#stdout:OK
