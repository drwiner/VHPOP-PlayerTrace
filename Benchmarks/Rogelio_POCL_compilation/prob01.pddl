(define (problem STORY)
   (:domain HYRULE)
   (:objects
        ;; Dramatis Personae
        arthur mel alli michael ian giovanna james dorian jordan - character
        camille phillip avery peter frank - character
        roger dave karina matthias oscar - character

        ;; Locations
        junkyard docks bar townarch townsquare hut forge shop - location
        bank valley fort cliff mansion - location
        basement storage - location ;; <- used for the tutorial

        ;; Entrances
        basemententrance basementexit - entrance
        barentrance barexit - entrance
        hutentrance hutexit - entrance
        forgeentrance forgeexit - entrance
        shopentrance shopexit - entrance
        bankentrance bankexit - entrance
        fortentrance fortexit - entrance
        mansionentrance mansionexit - entrance

        ;; Items
        knightsword knightshield rubyring coin humanskull candle lovecontract - item
        tastycupcake shinykey loveletter hairtonic bouquet - item
        rope book bucket mirror mushroom silver ash - item
        basementexitkey basementbucket - item

        ;; Doors
        towngate - door

        ;; Character Prefabs
        player wizard orc riddler quartermaster appraiser fortuneteller knight - prefab
        paladin baron baroness governor majordomo blacksmith banker - prefab
        citizenone citizentwo apprentice barkeep - prefab

        ;; Location Prefabs
        sand woods cave town beach junk woodenhouse brickhouse cliffedge - prefab

        ;; Item Prefabs
        woodendoor gate - prefab
        sword shield ring key coins skull candlestick cupcake contract letter tonic flowers - prefab
        lasso openbook pailofwater glassmirror tinymushroom silverbullion cat - prefab
   )
   (:init
        ;; Player Character
        (player arthur)

        ;; ---- Characters ----
        (prefab arthur player)
        (prefab mel wizard)
        (prefab michael fortuneteller)
        (prefab ian quartermaster)
        (prefab alli orc)
        (prefab giovanna appraiser)
        (prefab dorian knight)
        (prefab jordan paladin)
        (prefab james riddler)
        (prefab camille baroness)
        (prefab phillip baron)
        (prefab roger governor)
        (prefab avery majordomo)
        (prefab peter blacksmith)
        (prefab frank banker)
        (prefab dave citizenone)
        (prefab karina citizentwo)
        (prefab matthias apprentice)
        (prefab oscar barkeep)

        ;; ---- Items ----
        (prefab knightsword sword)
        (prefab rubyring ring)
        (prefab knightshield shield)
        (prefab tastycupcake cupcake)
        (prefab ash cat)
        (prefab coin coins)
        (prefab lovecontract contract)
        (prefab humanskull skull)
        (prefab candle candlestick)
        (prefab loveletter letter)
        (prefab hairtonic tonic)
        (prefab bouquet flowers)
        (prefab silver silverbullion)
        (prefab rope lasso)
        (prefab book openbook)
        (prefab bucket pailofwater)
        (prefab mirror glassmirror)
        (prefab mushroom tinymushroom)
        (prefab basementbucket pailofwater)


        ;; ---- Keys and Locks ----
        (prefab shinykey key)
        (unlocks shinykey bankentrance)
        (prefab towngate gate)

        (prefab basementexitkey key)
        (unlocks basementexitkey basementexit)

        ;; ---- Locations ----
        (prefab junkyard junk)
        (prefab docks beach)
        (prefab bar woodenhouse)
        (prefab storage brickhouse)
        (prefab basement brickhouse)
        (prefab townarch town)
        (prefab hut woodenhouse)
        (prefab forge woodenhouse)
        (prefab townsquare town)
        (prefab shop brickhouse)
        (prefab bank brickhouse)
        (prefab valley cave)
        (prefab fort brickhouse)
        (prefab cliff cliffedge)
        (prefab mansion brickhouse)


        ;; ---- Entrances ----
        (prefab barentrance woodendoor)
        (prefab barexit woodendoor)

        (prefab basemententrance woodendoor)
        (prefab basementexit woodendoor)

        (prefab forgeentrance woodendoor)
        (prefab forgeexit woodendoor)

        (prefab hutentrance woodendoor)
        (prefab hutexit woodendoor)

        (prefab shopentrance woodendoor)
        (prefab shopexit woodendoor)

        (prefab bankentrance woodendoor)
        (prefab bankexit woodendoor)

        (prefab fortentrance woodendoor)
        (prefab fortexit woodendoor)

        (prefab mansionentrance woodendoor)
        (prefab mansionexit woodendoor)



        ;; ---- World Map ----

        ;; The junkyard connects to the docks
        (connected junkyard docks)        (doorway junkyard docks)
        (connected docks junkyard)        (doorway docks junkyard)


        ;; The docks contains the bar and connects to the town archway
        (at barentrance docks)            (leadsto barentrance bar)
        (at barexit bar)                  (leadsto barexit docks)
        (closed barexit)

        ;; The bar contains the basement, which connects to the storage room.
        (at basemententrance bar)         (leadsto basemententrance basement)
        (at basementexit basement)        (leadsto basementexit bar)
        (closed basementexit)
        (locked basementexit)

        (connected storage basement)      (doorway storage basement)
        (connected basement storage)      (doorway basement storage)

        (connected docks townarch)        (doorway docks townarch)
        (connected townarch docks)        (doorway townarch docks)


        ;; The town archway contains the forge and the hut and connects to the townsquare
        (at forgeentrance townarch)       (leadsto forgeentrance forge)
        (at forgeexit forge)              (leadsto forgeexit townarch)
        (closed forgeentrance)

        (at hutentrance townarch)         (leadsto hutentrance hut)
        (at hutexit hut)                  (leadsto hutexit townarch)
        (closed hutentrance)

        (connected townarch townsquare)   (doorway townarch townsquare)
        (connected townsquare townarch)   (doorway townsquare townarch)
        ;; (locked towngate)


        ;; The town square contains the shop and the bank, and connects to the cliff and valley
        (at shopentrance townsquare)      (leadsto shopentrance shop)
        (at shopexit shop)                (leadsto shopexit townsquare)
        (closed shopentrance)

        (at bankentrance townsquare)      (leadsto bankentrance bank)
        (at bankexit bank)                (leadsto bankexit townsquare)
        (closed bankentrance)
        (locked bankentrance)

        (connected townsquare valley)     (doorway townsquare valley)
        (connected valley townsquare)     (doorway valley townsquare)

        (connected townsquare cliff)      (doorway townsquare cliff)
        (connected cliff townsquare)      (doorway cliff townsquare)


        ;; The cliff contains the mansion
        (at mansionentrance cliff)        (leadsto mansionentrance mansion)
        (at mansionexit mansion)          (leadsto mansionexit cliff)
        (closed mansionentrance)


        ;; The valley contains the fort
        (at fortentrance valley)      (leadsto fortentrance fort)
        (at fortexit fort)            (leadsto fortexit valley)
        (closed fortentrance)


        ;; ---- Initial Configuration ----

        ;; >>>> Player Configuration <<<<
        (at mel storage)        ;; (wants-item mel basementbucket) -> added dynamically
                                (willing-to-give-item mel basementexitkey)


        (at arthur storage)     (wants-item arthur ash)
                                (wants-item arthur shinykey)
                                (wants-item arthur loveletter)
                                (wants-item arthur lovecontract)
                                (willing-to-give-item arthur loveletter)
                                (willing-to-give-item arthur lovecontract)
                                (willing-to-give-item arthur ash)

        ;; >>>> Tutorial <<<<
        (at basementbucket basement)
        (has mel basementexitkey)



        ;; >>>> Pilgrimage Quest Configuration <<<<
        (at alli junkyard)      (has alli ash)
                                ;; (wants-item alli tastycupcake) -> added dynamically
                                ;; (willing-to-give-item alli ash) -> added dynamically

        (at michael hut)        (at tastycupcake hut)

		    (at frank townsquare)

        ;; >>>> Equip Quest Configuration <<<<
        (at ian fort)           ;; (wants-item ian knightsword) -> added dynamically
                                ;; (wants-item ian knightshield) -> added dynamically
        (at camille fort)
        (at phillip fort)
                                (at knightsword forge)


        (at giovanna shop)       (at knightshield shop)
                                 (at rubyring shop)


        ;; >>>> Wisdom Quest Configuration <<<<
        (at james valley)        ;; (wants-item james pileofcoins) -> added dynamically
                                 ;; (wants-item james humanskull) -> added dynamically
                                 ;; (wants-item james candelabra) -> added dynamically

                                 (at coin bank)
                                 (at humanskull cliff)
                                 (at candle mansion)
                                 (at shinykey bar)

        ;; >>>> Love Quest Configuration <<<<
        (at dorian townarch)     (has dorian loveletter)
                                 (has dorian lovecontract)
                                 ;; (willing-to-give-item dorian loveletter) -> added dynamically
                                 ;; (wants-item dorian rubyring) -> added dynamically
                                 ;; (wants-item dorian bouquet) -> added dynamically
                                 ;; (willing-to-give-item dorian lovecontract) -> added dynamically

                                 (at bouquet cliff)


        (at jordan mansion)      (wants-item jordan loveletter)
                                 (wants-item jordan lovecontract)

        (at avery mansion)


        ;; >>>> Fetch Quest Configuration <<<<
        (at peter forge)         ;; (wants-item giovanna hairtonic) -> added dynamically
                                 (at hairtonic hut)

        ;; >>>> Set Dressing Configuration <<<<
        (at roger mansion)
        (at rope forge)
        (at bucket fort)
        (at mirror junkyard)
        (at book hut)
        (at mushroom docks)
        (at dave townsquare)
        (at karina townarch)
        (at matthias forge)
        (at silver bank)
        (at oscar bar)
    )
    (:goal
        (and
			;; Equip Quest
			;; (has ian knightsword) -> added dynamically
			;; (has ian knightshield) -> added dynamically

			;; Pilgrimage Quest
			;; (has alli tastycupcake) -> added dynamically

			;; Wisdom Quest
			;; (has james coin) -> added dynamically
			;; (has james humanskull) -> added dynamically
			;; (has james candle) -> added dynamically

			;; Fetch Quest
			;; (has giovanna hairtonic) -> added dynamically

			;; Love Quest
			;; (has jordan loveletter) -> added dynamically
			;; (has jordan lovecontract) -> added dynamically

			;; Other
			;; (has arthur ash) -> added dynamically

			;; The Win Condition!
			(game-has-been-won)
        )
    )
)
