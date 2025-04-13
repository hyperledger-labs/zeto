pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier_Qurrency {
    // Scalar field size
    uint256 constant r =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q =
        21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax =
        7753535286662161526346421813346176704390878990527578655179859914813173996230;
    uint256 constant alphay =
        20189364517356084767670454912777340676644376660895095703647808852540236988379;
    uint256 constant betax1 =
        20022831253023213665568422252296730885922551076487557577019347812830821014904;
    uint256 constant betax2 =
        5404385705050718917013116841869304488836532734450623486486437607231023368204;
    uint256 constant betay1 =
        15298213039680111785844627100252392301990967451882716529517168760863700531889;
    uint256 constant betay2 =
        11486780275051928607228873431577792258348463898598859146360166024119283611667;
    uint256 constant gammax1 =
        20616326019406871287349131197697413258685857144711320006976562022747717950410;
    uint256 constant gammax2 =
        9847716930410327826943481507867685386374888696239106058075309889639560248075;
    uint256 constant gammay1 =
        16282478683362249615310775238539280805074458253219055864911180472565629783898;
    uint256 constant gammay2 =
        14631034052810957264645602520259549712048753084544736662198126012182426125881;
    uint256 constant deltax1 =
        5527822087112864180410202673772469341608796766489162210984594998313953928242;
    uint256 constant deltax2 =
        4978039297789442735295996766008770313328255274421847825981560695324836659714;
    uint256 constant deltay1 =
        13598101721989591384134744673934278625248786149079566932718956836387590711694;
    uint256 constant deltay2 =
        4173032444232374495921095107291212386419889077706980478956672109401142933674;

    uint256 constant IC0x =
        226635767651961119121795322620914482016405135000714054475793561819783189917;
    uint256 constant IC0y =
        15387929509263625326029757977887905112801037282011590145209502567711736039963;

    uint256 constant IC1x =
        13231191599785705559564579804207761959348527992118886228683909869795832775710;
    uint256 constant IC1y =
        18821550719161001234902637704187257314507005666713429724050427300575841280200;

    uint256 constant IC2x =
        2355231157556302441525135873208086545801064645241112731066145173553029385896;
    uint256 constant IC2y =
        17321180179446227316343847788094322541340425347842790203857491362440256019381;

    uint256 constant IC3x =
        12001791302049976285075005653125125647013814041595232124337948431982486809302;
    uint256 constant IC3y =
        15429596600402778300985866991904821311930861457715389622130089149757370712206;

    uint256 constant IC4x =
        20908624264001043229552654173300810358262730173969369626302232067683586303850;
    uint256 constant IC4y =
        20270159093039702750879572841888895277986376089566496667943984904070736582605;

    uint256 constant IC5x =
        20687044404998417538514902531767382301180489890132960062995850394290710262065;
    uint256 constant IC5y =
        8101852509400779166176691627465728729511524594433342708339210287775359004357;

    uint256 constant IC6x =
        21089112442221036057923983449059461180883301921885425735226573753106990499634;
    uint256 constant IC6y =
        10296106583059776897903960632260021445581625744226975748582594681533628842370;

    uint256 constant IC7x =
        7003645481092712995997077494457741051304120221637869205464288037930206827444;
    uint256 constant IC7y =
        16866158998759484720577088044943664567888184190376703237111791366332621886227;

    uint256 constant IC8x =
        13977985241821430592132093978323668924784635915181416870660478031288452363155;
    uint256 constant IC8y =
        5382973587817547307387615589614184942573168595040085046893966036454311752031;

    uint256 constant IC9x =
        17527398234781136355961459905438396879093243840632776547290936689349117758513;
    uint256 constant IC9y =
        14870037708698124764594887550632070990108725038345941800896381341720156034813;

    uint256 constant IC10x =
        15350323644251860021686636735009775413450332755483356130390496203926426772204;
    uint256 constant IC10y =
        4039841993041263473366862290825242173358904534428350852428051495428392693615;

    uint256 constant IC11x =
        6704229963189151208418098298854356078728651955478168603316075897245435843018;
    uint256 constant IC11y =
        19593830168897767801400391026597867879915190452745284078133718138936361903756;

    uint256 constant IC12x =
        20491371401165141872839042036752172722761610974289450911203084095648666465176;
    uint256 constant IC12y =
        1715320322896660641769828135600538584187521371854766725252838646823523136858;

    uint256 constant IC13x =
        19589187172704093062260846007919927670959649289886756181248025802327602821866;
    uint256 constant IC13y =
        13615675554415604296786259687472263174026841369658379604040921537275135114449;

    uint256 constant IC14x =
        2258911912361494697288147935315374633895001762360510374378283957734291269111;
    uint256 constant IC14y =
        16685797402427512527271775810860711231276989860666806473678124184352935192070;

    uint256 constant IC15x =
        18949925377434402138800926077683784163233745834996834372194911747522079602906;
    uint256 constant IC15y =
        8661823622535247404902283055940613475016239385920066194543571813640264404562;

    uint256 constant IC16x =
        16857834866075093063991444162333164370404462716958369069396046541607346499430;
    uint256 constant IC16y =
        20779818520282233527245998788287687434614973765564045456996591481596285686398;

    uint256 constant IC17x =
        19114726755623976392150764649636098746180645206077841299771802824325315219707;
    uint256 constant IC17y =
        13445510805794244759214195843571821853405982987174721875246557407184693727257;

    uint256 constant IC18x =
        5791150278277914486346444314609551191629729418179773941254084010807682889403;
    uint256 constant IC18y =
        5174879392959830362368526503817909676378190064109917792650701481466737137859;

    uint256 constant IC19x =
        1154677440421948436035984196049142730936622039811866425446040749781606165864;
    uint256 constant IC19y =
        9903108957264228557500017274804114484286559344183982509192279136484996002210;

    uint256 constant IC20x =
        8519147077206503290331476958068449905160953913788433635480437092811406190753;
    uint256 constant IC20y =
        17554395760123111665569568945836009433566683181951418506465778149463486174727;

    uint256 constant IC21x =
        4998754640579589316593711694526640246391818624318044902336179815226369053856;
    uint256 constant IC21y =
        20870500522251138515818968193913343405589830187896358511929590931754682546986;

    uint256 constant IC22x =
        13389727779217199539630007739436912885300465673888002920854618764835257844705;
    uint256 constant IC22y =
        2284070248226934583578603027773174586819210931463860175601360515482055184396;

    uint256 constant IC23x =
        400731906607434972788026076404599731753224517165063075726861399838253031626;
    uint256 constant IC23y =
        16830048666116482437350604982855233439292904399983054706203182187743316899327;

    uint256 constant IC24x =
        21745989691808366516178279065295677286354328474703587246688241872641216719952;
    uint256 constant IC24y =
        4467289518707551301101947731036946606865462809799523959493700897960971166459;

    uint256 constant IC25x =
        5108436009525243876869752878903029090101780593561386143431988325028946992034;
    uint256 constant IC25y =
        20586168609262218110777495418462160780911993157852768305952778819988138096302;

    uint256 constant IC26x =
        10566873540070777019765454301071628514840616661224427307904774451009919946217;
    uint256 constant IC26y =
        11777680426908861040942384479384799081436299869066601448539962271966817390215;

    uint256 constant IC27x =
        4341259004102280324869392927796053818993782392962245102885676176838114038019;
    uint256 constant IC27y =
        15596803037223680885943933362909270481602003940872444834539879365055617865370;

    uint256 constant IC28x =
        18632921092080440645459999578036312069397650144224427050281977891420115810080;
    uint256 constant IC28y =
        19812155481777632179463840064587685318476839521441647564035104405363776298916;

    uint256 constant IC29x =
        19160831913864789020487551531894532663020168335384846721305029051504139948355;
    uint256 constant IC29y =
        5900839246187477404244670904106601241661565973923149008659086740408838112135;

    uint256 constant IC30x =
        248709641814721054843319153263496944657850072750931587617380550815082512191;
    uint256 constant IC30y =
        15501052861031913402867911598190363190001331328137947051424462980715228753414;

    uint256 constant IC31x =
        7404235791323593395087810596018982163020156842459279362424769787065650166753;
    uint256 constant IC31y =
        10221575596793993020461696780807095273522876513624705007293604229319163409271;

    uint256 constant IC32x =
        13609779485418277861149962593060447780538951609396864668620196455210655468558;
    uint256 constant IC32y =
        11266261997840384963289034593156640262664344641174483717917405420726306980162;

    uint256 constant IC33x =
        13159946261637876441634546509126242523739288052404551219933419850117090413571;
    uint256 constant IC33y =
        15195010310616498371298935426244742547315762262264463943274824732000835682360;

    uint256 constant IC34x =
        18442327495251759838783274309617333035803920997114868407079953580261199383071;
    uint256 constant IC34y =
        3130110232820409460178580472234919673186358163822380083370520783254106480058;

    uint256 constant IC35x =
        18022157243095016778291773240978707399120750541825067112372640494115584017144;
    uint256 constant IC35y =
        11293479073373182568650946866757268869952825032466954452989372470123166455261;

    uint256 constant IC36x =
        16038480761946864562660514761550160392385233896720348050369943743232796204263;
    uint256 constant IC36y =
        8816682558135390008302382037597352546697256603203509353242288706532981774629;

    uint256 constant IC37x =
        5714452184061764088451534341621204601937128831234596128191722380861250576122;
    uint256 constant IC37y =
        9363280055794671180340008532396503601069993379473430015122538907598596089537;

    uint256 constant IC38x =
        1007739511693463036299578772578742992455911551410670342125030753204879645216;
    uint256 constant IC38y =
        5725327035780552745115856652177772101749402834072920760769600523134218877152;

    uint256 constant IC39x =
        1568786168805471690026788061819732488316271671303245839226828497260919943587;
    uint256 constant IC39y =
        5227960630462779328242495133297579937376685099321408352688035541123466211048;

    uint256 constant IC40x =
        6883482962807160924627741053816253466743394109536565103056849824574745045871;
    uint256 constant IC40y =
        12294693881215331427329949296487949353333564220382058857888415506429733910036;

    uint256 constant IC41x =
        17293651405267815317574483767663460266174364420442559495722199099868712767149;
    uint256 constant IC41y =
        11778433250804903644779175338392645493061612273440397247262703029205164071189;

    uint256 constant IC42x =
        20846301273774043089359747398173051282488012881068187002355511394710407922140;
    uint256 constant IC42y =
        14154877707794158599221786335875084949924960709398449763666436659837650842058;

    uint256 constant IC43x =
        4289279302612977993478024569494718544000542765885744776171230046990112887744;
    uint256 constant IC43y =
        21526465612711612726855678194737637533621500122637188858981623820258996611748;

    uint256 constant IC44x =
        3945604774985254167069156388193536135908418256999379102544989455565933504741;
    uint256 constant IC44y =
        9021602505011982767934215645928262082212468007740070410834180529580188853444;

    uint256 constant IC45x =
        9150470118415603935356967394159068280397773880402481119967904992291201060461;
    uint256 constant IC45y =
        8367068106752868203765770203270352327561037611131554853766640905927983606718;

    uint256 constant IC46x =
        5371873842718798968258393587999427615203695855800333831380405952722637186200;
    uint256 constant IC46y =
        10977949427168329142161768465092997233479114246851240337664481293715977743887;

    uint256 constant IC47x =
        3736101158419611767074874064132745142218549672911813850819017999952433611904;
    uint256 constant IC47y =
        15117053824365976351741727675922353051565515910906627529661068309941406220431;

    uint256 constant IC48x =
        5832173738336111799016382180383851449610494386784163343732623576966737933294;
    uint256 constant IC48y =
        1510051368658252334181500205873511838338266998135193453342262778514372479260;

    uint256 constant IC49x =
        12304416528896321364786404689775051297084449290389621912548390295384290106362;
    uint256 constant IC49y =
        16768598628229864643491698639863235721481275854226701393672034644258045028160;

    uint256 constant IC50x =
        2863631289955647745255324334752646504665348849093810984330489807847030267589;
    uint256 constant IC50y =
        1573647343104560203197798757741085457941330845945319703885428888101139421109;

    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[50] calldata _pubSignals
    ) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x

                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                g1_mulAccC(
                    _pVk,
                    IC10x,
                    IC10y,
                    calldataload(add(pubSignals, 288))
                )
                g1_mulAccC(
                    _pVk,
                    IC11x,
                    IC11y,
                    calldataload(add(pubSignals, 320))
                )
                g1_mulAccC(
                    _pVk,
                    IC12x,
                    IC12y,
                    calldataload(add(pubSignals, 352))
                )
                g1_mulAccC(
                    _pVk,
                    IC13x,
                    IC13y,
                    calldataload(add(pubSignals, 384))
                )
                g1_mulAccC(
                    _pVk,
                    IC14x,
                    IC14y,
                    calldataload(add(pubSignals, 416))
                )
                g1_mulAccC(
                    _pVk,
                    IC15x,
                    IC15y,
                    calldataload(add(pubSignals, 448))
                )
                g1_mulAccC(
                    _pVk,
                    IC16x,
                    IC16y,
                    calldataload(add(pubSignals, 480))
                )
                g1_mulAccC(
                    _pVk,
                    IC17x,
                    IC17y,
                    calldataload(add(pubSignals, 512))
                )
                g1_mulAccC(
                    _pVk,
                    IC18x,
                    IC18y,
                    calldataload(add(pubSignals, 544))
                )
                g1_mulAccC(
                    _pVk,
                    IC19x,
                    IC19y,
                    calldataload(add(pubSignals, 576))
                )
                g1_mulAccC(
                    _pVk,
                    IC20x,
                    IC20y,
                    calldataload(add(pubSignals, 608))
                )
                g1_mulAccC(
                    _pVk,
                    IC21x,
                    IC21y,
                    calldataload(add(pubSignals, 640))
                )
                g1_mulAccC(
                    _pVk,
                    IC22x,
                    IC22y,
                    calldataload(add(pubSignals, 672))
                )
                g1_mulAccC(
                    _pVk,
                    IC23x,
                    IC23y,
                    calldataload(add(pubSignals, 704))
                )
                g1_mulAccC(
                    _pVk,
                    IC24x,
                    IC24y,
                    calldataload(add(pubSignals, 736))
                )
                g1_mulAccC(
                    _pVk,
                    IC25x,
                    IC25y,
                    calldataload(add(pubSignals, 768))
                )
                g1_mulAccC(
                    _pVk,
                    IC26x,
                    IC26y,
                    calldataload(add(pubSignals, 800))
                )
                g1_mulAccC(
                    _pVk,
                    IC27x,
                    IC27y,
                    calldataload(add(pubSignals, 832))
                )
                g1_mulAccC(
                    _pVk,
                    IC28x,
                    IC28y,
                    calldataload(add(pubSignals, 864))
                )
                g1_mulAccC(
                    _pVk,
                    IC29x,
                    IC29y,
                    calldataload(add(pubSignals, 896))
                )
                g1_mulAccC(
                    _pVk,
                    IC30x,
                    IC30y,
                    calldataload(add(pubSignals, 928))
                )
                g1_mulAccC(
                    _pVk,
                    IC31x,
                    IC31y,
                    calldataload(add(pubSignals, 960))
                )
                g1_mulAccC(
                    _pVk,
                    IC32x,
                    IC32y,
                    calldataload(add(pubSignals, 992))
                )
                g1_mulAccC(
                    _pVk,
                    IC33x,
                    IC33y,
                    calldataload(add(pubSignals, 1024))
                )
                g1_mulAccC(
                    _pVk,
                    IC34x,
                    IC34y,
                    calldataload(add(pubSignals, 1056))
                )
                g1_mulAccC(
                    _pVk,
                    IC35x,
                    IC35y,
                    calldataload(add(pubSignals, 1088))
                )
                g1_mulAccC(
                    _pVk,
                    IC36x,
                    IC36y,
                    calldataload(add(pubSignals, 1120))
                )
                g1_mulAccC(
                    _pVk,
                    IC37x,
                    IC37y,
                    calldataload(add(pubSignals, 1152))
                )
                g1_mulAccC(
                    _pVk,
                    IC38x,
                    IC38y,
                    calldataload(add(pubSignals, 1184))
                )
                g1_mulAccC(
                    _pVk,
                    IC39x,
                    IC39y,
                    calldataload(add(pubSignals, 1216))
                )
                g1_mulAccC(
                    _pVk,
                    IC40x,
                    IC40y,
                    calldataload(add(pubSignals, 1248))
                )
                g1_mulAccC(
                    _pVk,
                    IC41x,
                    IC41y,
                    calldataload(add(pubSignals, 1280))
                )
                g1_mulAccC(
                    _pVk,
                    IC42x,
                    IC42y,
                    calldataload(add(pubSignals, 1312))
                )
                g1_mulAccC(
                    _pVk,
                    IC43x,
                    IC43y,
                    calldataload(add(pubSignals, 1344))
                )
                g1_mulAccC(
                    _pVk,
                    IC44x,
                    IC44y,
                    calldataload(add(pubSignals, 1376))
                )
                g1_mulAccC(
                    _pVk,
                    IC45x,
                    IC45y,
                    calldataload(add(pubSignals, 1408))
                )
                g1_mulAccC(
                    _pVk,
                    IC46x,
                    IC46y,
                    calldataload(add(pubSignals, 1440))
                )
                g1_mulAccC(
                    _pVk,
                    IC47x,
                    IC47y,
                    calldataload(add(pubSignals, 1472))
                )
                g1_mulAccC(
                    _pVk,
                    IC48x,
                    IC48y,
                    calldataload(add(pubSignals, 1504))
                )
                g1_mulAccC(
                    _pVk,
                    IC49x,
                    IC49y,
                    calldataload(add(pubSignals, 1536))
                )
                g1_mulAccC(
                    _pVk,
                    IC50x,
                    IC50y,
                    calldataload(add(pubSignals, 1568))
                )

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(
                    add(_pPairing, 32),
                    mod(sub(q, calldataload(add(pA, 32))), q)
                )

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))

                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)

                let success := staticcall(
                    sub(gas(), 2000),
                    8,
                    _pPairing,
                    768,
                    _pPairing,
                    0x20
                )

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F

            checkField(calldataload(add(_pubSignals, 0)))
            checkField(calldataload(add(_pubSignals, 32)))
            checkField(calldataload(add(_pubSignals, 64)))
            checkField(calldataload(add(_pubSignals, 96)))
            checkField(calldataload(add(_pubSignals, 128)))
            checkField(calldataload(add(_pubSignals, 160)))
            checkField(calldataload(add(_pubSignals, 192)))
            checkField(calldataload(add(_pubSignals, 224)))
            checkField(calldataload(add(_pubSignals, 256)))
            checkField(calldataload(add(_pubSignals, 288)))
            checkField(calldataload(add(_pubSignals, 320)))
            checkField(calldataload(add(_pubSignals, 352)))
            checkField(calldataload(add(_pubSignals, 384)))
            checkField(calldataload(add(_pubSignals, 416)))
            checkField(calldataload(add(_pubSignals, 448)))
            checkField(calldataload(add(_pubSignals, 480)))
            checkField(calldataload(add(_pubSignals, 512)))
            checkField(calldataload(add(_pubSignals, 544)))
            checkField(calldataload(add(_pubSignals, 576)))
            checkField(calldataload(add(_pubSignals, 608)))
            checkField(calldataload(add(_pubSignals, 640)))
            checkField(calldataload(add(_pubSignals, 672)))
            checkField(calldataload(add(_pubSignals, 704)))
            checkField(calldataload(add(_pubSignals, 736)))
            checkField(calldataload(add(_pubSignals, 768)))
            checkField(calldataload(add(_pubSignals, 800)))
            checkField(calldataload(add(_pubSignals, 832)))
            checkField(calldataload(add(_pubSignals, 864)))
            checkField(calldataload(add(_pubSignals, 896)))
            checkField(calldataload(add(_pubSignals, 928)))
            checkField(calldataload(add(_pubSignals, 960)))
            checkField(calldataload(add(_pubSignals, 992)))
            checkField(calldataload(add(_pubSignals, 1024)))
            checkField(calldataload(add(_pubSignals, 1056)))
            checkField(calldataload(add(_pubSignals, 1088)))
            checkField(calldataload(add(_pubSignals, 1120)))
            checkField(calldataload(add(_pubSignals, 1152)))
            checkField(calldataload(add(_pubSignals, 1184)))
            checkField(calldataload(add(_pubSignals, 1216)))
            checkField(calldataload(add(_pubSignals, 1248)))
            checkField(calldataload(add(_pubSignals, 1280)))
            checkField(calldataload(add(_pubSignals, 1312)))
            checkField(calldataload(add(_pubSignals, 1344)))
            checkField(calldataload(add(_pubSignals, 1376)))
            checkField(calldataload(add(_pubSignals, 1408)))
            checkField(calldataload(add(_pubSignals, 1440)))
            checkField(calldataload(add(_pubSignals, 1472)))
            checkField(calldataload(add(_pubSignals, 1504)))
            checkField(calldataload(add(_pubSignals, 1536)))
            checkField(calldataload(add(_pubSignals, 1568)))

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
            return(0, 0x20)
        }
    }
}
