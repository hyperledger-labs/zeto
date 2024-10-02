// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier_AnonEncNullifierKycBatch {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay  = 9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1  = 4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2  = 6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1  = 21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2  = 10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant deltax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant deltay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant deltay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;

    
    uint256 constant IC0x = 5879424562730631873560665784311981595213572976855664375149709980743092774122;
    uint256 constant IC0y = 13206866748476381944629292199003231744773785152598965076883128035599867853787;
    
    uint256 constant IC1x = 15282169789980326971904550824335238386817848748909013580290859998714153769728;
    uint256 constant IC1y = 7499960709101510675913166010109648378980965365673629087882118678621184270437;
    
    uint256 constant IC2x = 3578459586325224532056059944917518839394519128400975273626895213233025670336;
    uint256 constant IC2y = 17272773564081154461128353182642362910499205594170594449333417484297773873573;
    
    uint256 constant IC3x = 197034807531520429878206256088701311239327312308013073003098805299375721937;
    uint256 constant IC3y = 14059242108758834267366855334344521020229378447514273990452780096596776533082;
    
    uint256 constant IC4x = 18305198359557417602536694816075366899249880978881100999493998698728306888415;
    uint256 constant IC4y = 16089041801360961313466420448295896469125318371148849197946752990398785394011;
    
    uint256 constant IC5x = 11885137273538506752867177832041138715922297357352324574957641675330052864331;
    uint256 constant IC5y = 4067584364717025687436527377627439802168472956336329842601632426166677343993;
    
    uint256 constant IC6x = 8148601523579419011847384792699764594853373827476934294033693993504233772399;
    uint256 constant IC6y = 16057316536979538282443076509777020106755449805698416567876341226059866009954;
    
    uint256 constant IC7x = 12037768234901220602199856820113797877041049700441298954046885550050522178585;
    uint256 constant IC7y = 9363281685682409209234935650420670943610610069381323832800642807907230747168;
    
    uint256 constant IC8x = 14646872255043112970272036075814269541536317995327049583097986395960777389618;
    uint256 constant IC8y = 1621333485711245705745205228004099054244081268449139556613989487296116782949;
    
    uint256 constant IC9x = 19775316132999776498759542735860347212819060939265685412419414428073052134627;
    uint256 constant IC9y = 4608687134445774707008293385324355359543041753591954775503016630583162119042;
    
    uint256 constant IC10x = 16099052095232546719802260030800595737783250507579665289906231650137389523504;
    uint256 constant IC10y = 7893724112620136209815945904734616456952347632915844876449990186798682877525;
    
    uint256 constant IC11x = 3056912874178986288838663096512087996708267905193213375559390706386163682872;
    uint256 constant IC11y = 1514638771682044463329095778824526109809967853966651241302585519766107582756;
    
    uint256 constant IC12x = 1404092927951756013597895730140839291183947294471377019561596136610998130440;
    uint256 constant IC12y = 15623773051151761186326761145515739573945050760726055768708771248158561498228;
    
    uint256 constant IC13x = 9576441620339730381094895314906773263527201645034383465123334083291711765836;
    uint256 constant IC13y = 9896797057488658161314137120206713724873513455207329772040002436841046850406;
    
    uint256 constant IC14x = 145601496683190083773803860467138899082020258784010268473738963322069542566;
    uint256 constant IC14y = 14007087225913531300142045107727112841821984494863605846003202076964654741568;
    
    uint256 constant IC15x = 3372190984533446456890699363025326068027012148844883516925962272413560151770;
    uint256 constant IC15y = 18560741302432737159517852251417424897074073126740660059701111852146993979497;
    
    uint256 constant IC16x = 19912215255388771485574384336706417867653797205425596845949286583447854648271;
    uint256 constant IC16y = 6995001075253251586380762968020241732919934674913639077980014146525990206684;
    
    uint256 constant IC17x = 5483240527666558072645510304792558005910843928871145092828007065898455887913;
    uint256 constant IC17y = 15440416814938865094565024254546293466987704590811833158431184937033918781241;
    
    uint256 constant IC18x = 14782297685341202881645774424037665327184105702945875674725280843137690447600;
    uint256 constant IC18y = 1620384386022682838962458121754764532173602828878779213885935960925184731325;
    
    uint256 constant IC19x = 1171688358275105292783738617724244003790699210255866338784729067962221252746;
    uint256 constant IC19y = 14281912851508071024054994668242637687301935221249367382342439540731810886364;
    
    uint256 constant IC20x = 20347527434246834723282148235319426299066672911747060033126978550391175449445;
    uint256 constant IC20y = 5303220787428916539470377959086980264518321061473367573230745434641333240835;
    
    uint256 constant IC21x = 19179731889554897057776804513279793130466426954972425189219331958526076016887;
    uint256 constant IC21y = 4445528599037546946777217693890113870365663777965295532448953807555220602911;
    
    uint256 constant IC22x = 11806165497541944446376391657387565359407103613171987109320808599242802716209;
    uint256 constant IC22y = 14737637212042438668460307240543825758060318730491247469945951452640347707548;
    
    uint256 constant IC23x = 13851363581844588948052079333589972202899416739082046495735113810033698241162;
    uint256 constant IC23y = 7198459307783162593588249279195591466526828528293563672399089446016016248828;
    
    uint256 constant IC24x = 7323586796583915538517203253475425596568875649851764668132652747576897356674;
    uint256 constant IC24y = 9729449148236190158990275233658468848836238158974702870478357903438559769579;
    
    uint256 constant IC25x = 13062739373677177356285877655756540319700401112341451458289018760065571317356;
    uint256 constant IC25y = 6988216302343924340288284552829649507771461236411942619714230419889112890232;
    
    uint256 constant IC26x = 2464215550608163570038501219646000285436003972199334545314794238287607467824;
    uint256 constant IC26y = 16620971382566073073128670286766287985754203816896866852368294400912265894110;
    
    uint256 constant IC27x = 20940040750330519406230306223206959132162605675817097713078739721349293057417;
    uint256 constant IC27y = 21287713070208274602768525363434407364711158919815391235905594775885332798341;
    
    uint256 constant IC28x = 6401729451874095801187728414284491748130061433879980220338030275579186819738;
    uint256 constant IC28y = 13937574244579894959948501614829150203297890136818974290229078781393132607873;
    
    uint256 constant IC29x = 9368391468110987658570378975892753259540418036926848523586290852343199284773;
    uint256 constant IC29y = 107729344928419472941901678296319367646979433201813012887361138123247414839;
    
    uint256 constant IC30x = 2465894890831381993380825656243358825257823266694928961517668757124215052934;
    uint256 constant IC30y = 15873045630070953074394329139768616105680399126773880505061342476653353822689;
    
    uint256 constant IC31x = 7084362018026161779770911586531273766785690156040435490420195876990482099784;
    uint256 constant IC31y = 2394109909281977185888124670377335145609878915972731855891616452361034008333;
    
    uint256 constant IC32x = 17050076019156816070944281280708943910838920040776857008320640503046547150705;
    uint256 constant IC32y = 15441033341296752528073976522603243961612433476509181204526290320086756678144;
    
    uint256 constant IC33x = 17007360840996458735533259298276500721591653279705741864746192509196970296979;
    uint256 constant IC33y = 12686223349904100427859931074755256614188491863578850524425378118131427547603;
    
    uint256 constant IC34x = 7174987464014142375128567768481998931345937721829236042612567921367171113916;
    uint256 constant IC34y = 10609882706640379435056873300851937306890039989866004929634236687903425161370;
    
    uint256 constant IC35x = 20885845815333350431275596172977175238706110033489472890774307126717679622248;
    uint256 constant IC35y = 17135686419293960728794078095089698333457463514785430109646825105502189336669;
    
    uint256 constant IC36x = 9664385680491244785981775913431166433938498751667358805274275141467748961484;
    uint256 constant IC36y = 16332287488121385056121855611920427331672197271015405247318684627848158882262;
    
    uint256 constant IC37x = 15913940110854022852039504331149734321941602181835159950530732042560603305642;
    uint256 constant IC37y = 13777192189726860016802262305494521208478001078062908762352000876574019828737;
    
    uint256 constant IC38x = 12185388915386862382750652679425907611744048678894608940766319281177016330242;
    uint256 constant IC38y = 11388932634998818972372804947505502471386893327502266656159412742925186744156;
    
    uint256 constant IC39x = 5318225103964474198489064177399855799456337524169256962784459861800216008249;
    uint256 constant IC39y = 14693450832931138489723451342673318007939221559303114206375131645927124667178;
    
    uint256 constant IC40x = 4539243343942623689570251191768100792555822101624054774825384133860358252096;
    uint256 constant IC40y = 7000277072004524055112142174982168227316352091208263052411492677723204147201;
    
    uint256 constant IC41x = 6570604828233255163987182543549279371016809764127851071270147347934510731037;
    uint256 constant IC41y = 17877458349499320502633124552480378264058983829327733078020944292262113498032;
    
    uint256 constant IC42x = 20473872403685799935913837068751302263965756852764538003563229844964853952896;
    uint256 constant IC42y = 14453693115236959093382101734403849518452527195272893059887284625808299545272;
    
    uint256 constant IC43x = 179332133019483352438736556438835523968308233835571076021869431262538088841;
    uint256 constant IC43y = 21084723578643159210550665732319238098045251334026347455884481703971893467477;
    
    uint256 constant IC44x = 6519245332321709834372618981635946116314695901293520552659744932664932571858;
    uint256 constant IC44y = 9553619290856814915870116705308451598280045588238540889066732336668200195537;
    
    uint256 constant IC45x = 17098401875622299082871013024128477847005619368976977771475382962032361024522;
    uint256 constant IC45y = 16711078716343061402442750765152909900789642769078913703416407681486602210531;
    
    uint256 constant IC46x = 6937301436998009285639202261617257662054184175035299414644515067014280276964;
    uint256 constant IC46y = 13412747294496809883486271133731861953691100148664645738700749132634631608997;
    
    uint256 constant IC47x = 17251101177466634404443311467132387586379227953585655692707127242790857814231;
    uint256 constant IC47y = 32257460652713777703856951582453790239735732365781343371118959671852356494;
    
    uint256 constant IC48x = 453359389862300317138205574315956647398789221013682535590200718760411858323;
    uint256 constant IC48y = 12215660590080857007159353422330437862387740196299978651691652936335774702882;
    
    uint256 constant IC49x = 13636743361866170840377237612947726735204038302483096074368054786666685953195;
    uint256 constant IC49y = 1404676530495469308352138721426302146045719996446356694900958006899504769898;
    
    uint256 constant IC50x = 6918788721383830371056271655744737593186437739010102936644481559276561787888;
    uint256 constant IC50y = 3145930382218912939068735275559282673416206862818243206096217871999892204055;
    
    uint256 constant IC51x = 3130812576532245412344213636666430939233954508715036438531282599785303888120;
    uint256 constant IC51y = 12638671175273949730705239111814852209407283415272117295269734572775765002752;
    
    uint256 constant IC52x = 10685875146445011461742284952763738571177731891982079198663348694402647405887;
    uint256 constant IC52y = 8804518745723901478761359698953547104817786749784981253214284229160017198613;
    
    uint256 constant IC53x = 20356422202910078499466233407220602392996353698947129037914752294314441521979;
    uint256 constant IC53y = 12341505800666039726647642369806900907171401046256443281976478320185405546510;
    
    uint256 constant IC54x = 18888410617119335703265049400236908967880231581094392176138244827031551448084;
    uint256 constant IC54y = 14703600171645145074092717976923536856751011588829788080513083721549359490915;
    
    uint256 constant IC55x = 9139933829013975729932767940105346648472763059585218042515535725324925300708;
    uint256 constant IC55y = 9035126453163676347404515495522257784660517669211308097846825350810671514050;
    
    uint256 constant IC56x = 16805216642060232239806458278045945563759453156092815642832654202399345331469;
    uint256 constant IC56y = 16195117201742272275205642165848969713997209938681512172560555859793361066641;
    
    uint256 constant IC57x = 14432795835860635317192599110876979776021227976713244509387348724736478965818;
    uint256 constant IC57y = 2261277026432232749652728598112671195687697376372442265420855576717426239367;
    
    uint256 constant IC58x = 18988365762278509991919793866822703031767326961150015214334532923046884467072;
    uint256 constant IC58y = 19316032093341265221242837019522075912460038712742656856976255161022717799293;
    
    uint256 constant IC59x = 11599328628785806782044241002749534811867428529524396134455388421901872046398;
    uint256 constant IC59y = 14619917552527905729476568744185523912015434998642833355371059807619892609155;
    
    uint256 constant IC60x = 12970497412633149236620211657305192135277913186555572451418836618314360759077;
    uint256 constant IC60y = 1535577522461044270097258412071009752049795294677712965767379674769842237874;
    
    uint256 constant IC61x = 16308302680176784246305193447120497869389849465306309331472801130297223731250;
    uint256 constant IC61y = 5045808378861381077608639873267624614673859039956914189704301231382082230903;
    
    uint256 constant IC62x = 7614300032801510129936567013327252517766986398776187358029812463847907675610;
    uint256 constant IC62y = 843028173085863976591548286083503526126799553429854908040003115547529382055;
    
    uint256 constant IC63x = 2305356977905353068532348127807280458408372305687029871425764875582080747207;
    uint256 constant IC63y = 11369807553091069259993055000449612405152154303288384321485662380454736384661;
    
    uint256 constant IC64x = 5893655752232338928880238258827141723569138756601823772221555929721274837767;
    uint256 constant IC64y = 762627208092203787014413477906318870348178681190360427769983760118925140877;
    
    uint256 constant IC65x = 7647050923225457883297743290621393989245647154580932694210685595827869846975;
    uint256 constant IC65y = 6430806084903190813114000641169996717167510218721465751246980030700445398359;
    
    uint256 constant IC66x = 10705759571794772559379223851331014817700674885465595035867220237046106842609;
    uint256 constant IC66y = 7575242100365466110879455572056523744009175131712325621201550128707014694573;
    
    uint256 constant IC67x = 19335371568205325600215177798281256377744361599419598912087908330327748044026;
    uint256 constant IC67y = 18744946889655449235399670789159468543539893777461000723720969641977783074229;
    
    uint256 constant IC68x = 9767942356930193944620098079884247644024369691632397734905144035492042213721;
    uint256 constant IC68y = 11085556109902571980824189630955599575123617802526024300718206179448320548625;
    
    uint256 constant IC69x = 13561415355142249310381619037303986562854893588893292551203587367077511859228;
    uint256 constant IC69y = 1464204294678453347403309758878730755684248437324144097986974213671657291740;
    
    uint256 constant IC70x = 2978997668350654766587871166804311940266365978582703006605099063381084149576;
    uint256 constant IC70y = 4691523802837523050382298118755178847780158086994967423520861950486681484572;
    
    uint256 constant IC71x = 13787610941587889897421513807604767014830351081556468843341653766152135431648;
    uint256 constant IC71y = 799692903698551254826261186128856317901438765767986583443960026939465662552;
    
    uint256 constant IC72x = 5657017403698293692969857796776966712277738573977778673163309275184923732657;
    uint256 constant IC72y = 13494088133970364611964768081664124413588123681546171311645509845722766195409;
    
    uint256 constant IC73x = 15024370789171219079614745803857855731467108973725111688470085615714055290512;
    uint256 constant IC73y = 5751357237078772693350680556024857842294310641081411422830969005029413202669;
    
    uint256 constant IC74x = 7767473419872803360280996619556374816181543250685563965702004358978764765995;
    uint256 constant IC74y = 15787806098561035204238058185216611790078178948682839778120573240231960752797;
    
    uint256 constant IC75x = 20801429324948292817168863560873473171225815932214644882221971484645218719171;
    uint256 constant IC75y = 32314334472142699140647959677929936627127548500320734326413014995862964849;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[75] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                
                g1_mulAccC(_pVk, IC43x, IC43y, calldataload(add(pubSignals, 1344)))
                
                g1_mulAccC(_pVk, IC44x, IC44y, calldataload(add(pubSignals, 1376)))
                
                g1_mulAccC(_pVk, IC45x, IC45y, calldataload(add(pubSignals, 1408)))
                
                g1_mulAccC(_pVk, IC46x, IC46y, calldataload(add(pubSignals, 1440)))
                
                g1_mulAccC(_pVk, IC47x, IC47y, calldataload(add(pubSignals, 1472)))
                
                g1_mulAccC(_pVk, IC48x, IC48y, calldataload(add(pubSignals, 1504)))
                
                g1_mulAccC(_pVk, IC49x, IC49y, calldataload(add(pubSignals, 1536)))
                
                g1_mulAccC(_pVk, IC50x, IC50y, calldataload(add(pubSignals, 1568)))
                
                g1_mulAccC(_pVk, IC51x, IC51y, calldataload(add(pubSignals, 1600)))
                
                g1_mulAccC(_pVk, IC52x, IC52y, calldataload(add(pubSignals, 1632)))
                
                g1_mulAccC(_pVk, IC53x, IC53y, calldataload(add(pubSignals, 1664)))
                
                g1_mulAccC(_pVk, IC54x, IC54y, calldataload(add(pubSignals, 1696)))
                
                g1_mulAccC(_pVk, IC55x, IC55y, calldataload(add(pubSignals, 1728)))
                
                g1_mulAccC(_pVk, IC56x, IC56y, calldataload(add(pubSignals, 1760)))
                
                g1_mulAccC(_pVk, IC57x, IC57y, calldataload(add(pubSignals, 1792)))
                
                g1_mulAccC(_pVk, IC58x, IC58y, calldataload(add(pubSignals, 1824)))
                
                g1_mulAccC(_pVk, IC59x, IC59y, calldataload(add(pubSignals, 1856)))
                
                g1_mulAccC(_pVk, IC60x, IC60y, calldataload(add(pubSignals, 1888)))
                
                g1_mulAccC(_pVk, IC61x, IC61y, calldataload(add(pubSignals, 1920)))
                
                g1_mulAccC(_pVk, IC62x, IC62y, calldataload(add(pubSignals, 1952)))
                
                g1_mulAccC(_pVk, IC63x, IC63y, calldataload(add(pubSignals, 1984)))
                
                g1_mulAccC(_pVk, IC64x, IC64y, calldataload(add(pubSignals, 2016)))
                
                g1_mulAccC(_pVk, IC65x, IC65y, calldataload(add(pubSignals, 2048)))
                
                g1_mulAccC(_pVk, IC66x, IC66y, calldataload(add(pubSignals, 2080)))
                
                g1_mulAccC(_pVk, IC67x, IC67y, calldataload(add(pubSignals, 2112)))
                
                g1_mulAccC(_pVk, IC68x, IC68y, calldataload(add(pubSignals, 2144)))
                
                g1_mulAccC(_pVk, IC69x, IC69y, calldataload(add(pubSignals, 2176)))
                
                g1_mulAccC(_pVk, IC70x, IC70y, calldataload(add(pubSignals, 2208)))
                
                g1_mulAccC(_pVk, IC71x, IC71y, calldataload(add(pubSignals, 2240)))
                
                g1_mulAccC(_pVk, IC72x, IC72y, calldataload(add(pubSignals, 2272)))
                
                g1_mulAccC(_pVk, IC73x, IC73y, calldataload(add(pubSignals, 2304)))
                
                g1_mulAccC(_pVk, IC74x, IC74y, calldataload(add(pubSignals, 2336)))
                
                g1_mulAccC(_pVk, IC75x, IC75y, calldataload(add(pubSignals, 2368)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

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


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

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
            
            checkField(calldataload(add(_pubSignals, 1600)))
            
            checkField(calldataload(add(_pubSignals, 1632)))
            
            checkField(calldataload(add(_pubSignals, 1664)))
            
            checkField(calldataload(add(_pubSignals, 1696)))
            
            checkField(calldataload(add(_pubSignals, 1728)))
            
            checkField(calldataload(add(_pubSignals, 1760)))
            
            checkField(calldataload(add(_pubSignals, 1792)))
            
            checkField(calldataload(add(_pubSignals, 1824)))
            
            checkField(calldataload(add(_pubSignals, 1856)))
            
            checkField(calldataload(add(_pubSignals, 1888)))
            
            checkField(calldataload(add(_pubSignals, 1920)))
            
            checkField(calldataload(add(_pubSignals, 1952)))
            
            checkField(calldataload(add(_pubSignals, 1984)))
            
            checkField(calldataload(add(_pubSignals, 2016)))
            
            checkField(calldataload(add(_pubSignals, 2048)))
            
            checkField(calldataload(add(_pubSignals, 2080)))
            
            checkField(calldataload(add(_pubSignals, 2112)))
            
            checkField(calldataload(add(_pubSignals, 2144)))
            
            checkField(calldataload(add(_pubSignals, 2176)))
            
            checkField(calldataload(add(_pubSignals, 2208)))
            
            checkField(calldataload(add(_pubSignals, 2240)))
            
            checkField(calldataload(add(_pubSignals, 2272)))
            
            checkField(calldataload(add(_pubSignals, 2304)))
            
            checkField(calldataload(add(_pubSignals, 2336)))
            
            checkField(calldataload(add(_pubSignals, 2368)))
            
            checkField(calldataload(add(_pubSignals, 2400)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
