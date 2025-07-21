# Test t03.s - Test de la routine mGen avec allocation dynamique

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

    # Variables pour stocker les adresses des personnes créées
    addr_grandpere: .dword 0
    addr_pere: .dword 0
    addr_mere: .dword 0
    addr_enfant1: .dword 0
    addr_enfant2: .dword 0

.text

    # Créer la famille avec allocation dynamique

    # Créer le grand-père (pas de parents)
    li a0, 1950     # année de naissance
    li a1, 0        # pas de père
    li a2, 0        # pas de mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_grandpere
    sd a0, 0(t0)    # Sauvegarder l'adresse du grand-père

    # Créer la mère (pas de parents)
    li a0, 1978     # année de naissance
    li a1, 0        # pas de père
    li a2, 0        # pas de mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_mere
    sd a0, 0(t0)    # Sauvegarder l'adresse de la mère

    # Créer le père (grand-père comme père)
    li a0, 1975     # année de naissance
    la t0, addr_grandpere
    ld a1, 0(t0)    # père = grand-père
    li a2, 0        # pas de mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_pere
    sd a0, 0(t0)    # Sauvegarder l'adresse du père

    # Créer l'enfant1 (père et mère)
    li a0, 2000     # année de naissance
    la t0, addr_pere
    ld a1, 0(t0)    # père
    la t0, addr_mere
    ld a2, 0(t0)    # mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_enfant1
    sd a0, 0(t0)    # Sauvegarder l'adresse de l'enfant1

    # Créer l'enfant2 (père et mère)
    li a0, 2005     # année de naissance
    la t0, addr_pere
    ld a1, 0(t0)    # père
    la t0, addr_mere
    ld a2, 0(t0)    # mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_enfant2
    sd a0, 0(t0)    # Sauvegarder l'adresse de l'enfant2

    # Établir les relations parent-enfant avec addEnf

    # Ajouter le père comme enfant du grand-père
    la t0, addr_pere
    ld a0, 0(t0)        # adresse du père
    la t0, addr_grandpere
    ld a1, 0(t0)        # adresse du grand-père
    jal addEnf
    beq a0, zero, creation_fail

    # Ajouter enfant1 comme enfant du père
    la t0, addr_enfant1
    ld a0, 0(t0)        # adresse de l'enfant1
    la t0, addr_pere
    ld a1, 0(t0)        # adresse du père
    jal addEnf
    beq a0, zero, creation_fail

    # Ajouter enfant2 comme enfant du père
    la t0, addr_enfant2
    ld a0, 0(t0)        # adresse de l'enfant2
    la t0, addr_pere
    ld a1, 0(t0)        # adresse du père
    jal addEnf
    beq a0, zero, creation_fail

    # Ajouter enfant1 comme enfant de la mère
    la t0, addr_enfant1
    ld a0, 0(t0)        # adresse de l'enfant1
    la t0, addr_mere
    ld a1, 0(t0)        # adresse de la mère
    jal addEnf
    beq a0, zero, creation_fail

    # Ajouter enfant2 comme enfant de la mère
    la t0, addr_enfant2
    ld a0, 0(t0)        # adresse de l'enfant2
    la t0, addr_mere
    ld a1, 0(t0)        # adresse de la mère
    jal addEnf
    beq a0, zero, creation_fail

    # Test 1: Niveau de génération du grand-père
    la t0, addr_grandpere
    ld a0, 0(t0)
    jal mGen
    ld t0, niveau_attendu_grandpere
    bne a0, t0, test_fail

    # Test 2: Niveau de génération du père
    la t0, addr_pere
    ld a0, 0(t0)
    jal mGen
    ld t0, niveau_attendu_pere
    bne a0, t0, test_fail

    # Test 3: Niveau de génération de la mère
    la t0, addr_mere
    ld a0, 0(t0)
    jal mGen
    ld t0, niveau_attendu_mere
    bne a0, t0, test_fail

    # Test 4: Niveau de génération de l'enfant1
    la t0, addr_enfant1
    ld a0, 0(t0)
    jal mGen
    ld t0, niveau_attendu_enfant1
    bne a0, t0, test_fail

    # Test 5: Niveau de génération de l'enfant2
    la t0, addr_enfant2
    ld a0, 0(t0)
    jal mGen
    ld t0, niveau_attendu_enfant2
    bne a0, t0, test_fail

    # Test 6: Test avec paramètre NULL
    li a0, 0
    jal mGen
    bne a0, zero, test_fail     # Doit retourner 0 pour NULL

    # Tous les tests ont réussi
    j test_success

creation_fail:
    # Erreur lors de la création des personnes
    li a0, 0
    j test_fail

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
