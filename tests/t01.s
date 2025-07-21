# Test t01.s - Test de la routine newP

.data
    # Messages pour les tests
    msg_ok: .string "OK\n"
    msg_fail: .string "FAIL\n"

    # Valeurs de test
    test_annee: .dword 1990
    test_pere: .dword 0x1000    # Adresse fictive pour le père
    test_mere: .dword 0x2000    # Adresse fictive pour la mère

.text

    # Préparer les paramètres pour newP
    ld a0, test_annee          # a0 = année de naissance (1990)
    ld a1, test_pere           # a1 = adresse du père (0x1000)
    ld a2, test_mere           # a2 = adresse de la mère (0x2000)

    # Appeler la routine newP
    jal newP

    # Sauvegarder l'adresse du nouveau nœud
    mv s0, a0

    # Vérifier que l'allocation a réussi (adresse != 0)
    beq s0, zero, test_fail

    # Test 1: Vérifier le champ père
    ld t0, 0(s0)               # Charger le champ père
    ld t1, test_pere           # Charger la valeur attendue
    bne t0, t1, test_fail

    # Test 2: Vérifier le champ mère
    ld t0, 8(s0)               # Charger le champ mère
    ld t1, test_mere           # Charger la valeur attendue
    bne t0, t1, test_fail

    # Test 3: Vérifier l'année de naissance
    ld t0, 16(s0)              # Charger le champ année
    ld t1, test_annee          # Charger la valeur attendue
    bne t0, t1, test_fail

    # Test 4: Vérifier que la liste des enfants est initialisée à 0
    ld t0, 24(s0)              # Charger le champ liste des enfants
    bne t0, zero, test_fail

    # Test avec paramètres NULL
    # Créer un nouveau nœud avec père et mère = 0
    li a0, 2000                # année = 2000
    li a1, 0                   # père = 0
    li a2, 0                   # mère = 0

    jal newP

    # Vérifier que l'allocation a réussi
    beq a0, zero, test_fail
    mv s1, a0

    # Vérifier que les champs NULL sont bien à 0
    ld t0, 0(s1)               # Charger le champ père
    bne t0, zero, test_fail

    ld t0, 8(s1)               # Charger le champ mère
    bne t0, zero, test_fail

    # Vérifier l'année
    ld t0, 16(s1)              # Charger le champ année
    li t1, 2000
    bne t0, t1, test_fail

    # Vérifier que la liste des enfants est à 0
    ld t0, 24(s1)              # Charger le champ liste des enfants
    bne t0, zero, test_fail

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

#stdout:OK
