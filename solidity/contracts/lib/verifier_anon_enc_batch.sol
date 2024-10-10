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

contract Groth16Verifier_AnonEncBatch {
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

    
    uint256 constant IC0x = 17190705551387374165465630178414097882207179175808416998592104672042269145796;
    uint256 constant IC0y = 3326253291529306070732568800881802510427404631986019999432955654669384850411;
    
    uint256 constant IC1x = 9056390472479670450917040152074067224677908131790289664302602506677480851951;
    uint256 constant IC1y = 21757253069807310495476401204508619324839407168714508584654514015487358196590;
    
    uint256 constant IC2x = 2069077889203474724816447634850290436482175153772764866724239509530700894855;
    uint256 constant IC2y = 208730408261053193247666753865958284951853499381240921490613511706057823815;
    
    uint256 constant IC3x = 3290670235884248631506359174448134984445233397119031135129796340956777436744;
    uint256 constant IC3y = 9760219669615574514863218794396438511168675570983001450630727785007924125265;
    
    uint256 constant IC4x = 12919904718686658248054197412933615239403401430512363345376657087643920755223;
    uint256 constant IC4y = 7248244338513169966484555593146752396608270324481358498006089075574025976474;
    
    uint256 constant IC5x = 2691558500563695383361232490656352238556774483828798455821796957059966501672;
    uint256 constant IC5y = 352960762102970661800394160551776345637143894219021438415228630908954124083;
    
    uint256 constant IC6x = 18520511510550227927300479982157835181910123158464827146158177527544089295768;
    uint256 constant IC6y = 20419296272212947212216695670093334669202621379143200895464757793903971181114;
    
    uint256 constant IC7x = 7508741787655335082678183776755435685106979148194551309981416079715353356583;
    uint256 constant IC7y = 2407402477085667407046245036470553985246462229714505834190107059575903138299;
    
    uint256 constant IC8x = 18471669522613276880927322243943745047807588459927532872119704665432814226019;
    uint256 constant IC8y = 220974884629047711248636906223843138145797460237638863178879042569183993992;
    
    uint256 constant IC9x = 13345311726308524776318222905324880414181628361069254367702105291327468535151;
    uint256 constant IC9y = 7592910027522546290963914942103856601207471971485612198478973552339663568202;
    
    uint256 constant IC10x = 13274625120628505373297349036556342813233987616021013569948623159336109589281;
    uint256 constant IC10y = 18113361933410414139978744858333352312917924095523046414356847465270532816626;
    
    uint256 constant IC11x = 13865496460610830149622274536480856006956348689298181107698536163562712251309;
    uint256 constant IC11y = 4998598469936468120997364661012918161041745683420526844612371472037226418778;
    
    uint256 constant IC12x = 15976872676815625131186807117261916671320247985113346348950325657811291818119;
    uint256 constant IC12y = 20375165867414751656178029498100583187074051027121238559135499145614512941549;
    
    uint256 constant IC13x = 20668739717088740287358853136151547997596921248335389604371896008780216123075;
    uint256 constant IC13y = 11649672800935643198110650959294030572751613556584086602110166456386943463263;
    
    uint256 constant IC14x = 20178475187575318789395031779023360250749924418577873618972806103917126684375;
    uint256 constant IC14y = 15476975938044073054921421125111433839183811825798126430912366915592611217273;
    
    uint256 constant IC15x = 12340103227493922778456593173913260600880232919766506331150893300119897033299;
    uint256 constant IC15y = 3272680237518907406708321423224323767725085200156596393940832245136408787567;
    
    uint256 constant IC16x = 8657739707163007108055786839360950234976340035476906342847834451121317485691;
    uint256 constant IC16y = 3652426351246057898660024524828619564166560260344683916581259191484090434315;
    
    uint256 constant IC17x = 2389452475845900822444495096680736209381422044735491408786630034896721176883;
    uint256 constant IC17y = 9968271044019125687715476231282020447454258770597711658425115696467847213929;
    
    uint256 constant IC18x = 4361932226345633869318702800429127614954966728322972774836101260425413484935;
    uint256 constant IC18y = 15794927263351030509348601284219995252478560495831326295512532824437555021023;
    
    uint256 constant IC19x = 18472666759040770136040287734572476173488186713169725992540826148283192856060;
    uint256 constant IC19y = 6644107632317542213058387951921972647661332388291937544844303743391780397923;
    
    uint256 constant IC20x = 9829615215742981574535259935859032179976113887836305162146982668413983379592;
    uint256 constant IC20y = 13933695694553308407737899463836778942624743038377127579647661108746683485068;
    
    uint256 constant IC21x = 1190106005642629657179204847684671672693413803948536150966897205607062896189;
    uint256 constant IC21y = 7445344357214588757423998950551920035256982808944161212594755513433023796118;
    
    uint256 constant IC22x = 13560517120279809178159268592319171302690761333480060958385342523002582700755;
    uint256 constant IC22y = 14758334088619655322565352346349983260946614298381566173762007224105824914790;
    
    uint256 constant IC23x = 6120867825174283986836926728203292191380095094630398556979574683101447071744;
    uint256 constant IC23y = 2651465889259740475961949788686856113783362984495148404171493261034421508818;
    
    uint256 constant IC24x = 14744291168633475607835646215414672951228112731383085919073834113204906033436;
    uint256 constant IC24y = 12767950174224841741319025676084102284334909290812116709140408630955975715891;
    
    uint256 constant IC25x = 1786809097618922431706553976149086465073118915033069668657785636438093107253;
    uint256 constant IC25y = 10732778263613146492986207957226453655129865292705602688810713921319909556420;
    
    uint256 constant IC26x = 14981344630181179597682265301026870334035473194100264945231286188628996815361;
    uint256 constant IC26y = 6214431963167067471287444472312645702232742390916189034101528308225444821195;
    
    uint256 constant IC27x = 5893711315331155121990502514220597587208248975833788724596135914001006346006;
    uint256 constant IC27y = 18749665808474039346244394845184883127613662390188541835798463806875307217423;
    
    uint256 constant IC28x = 21027185610791690303253869994804969111616218804674113642453583565680209359764;
    uint256 constant IC28y = 7936209694667761102864394112090767125068090722954784444358146794017232155146;
    
    uint256 constant IC29x = 16440749915049905568771710852842016704065906853006987246654318326583685260058;
    uint256 constant IC29y = 2137563558912041291285106822634833183909274714607235644111021985752509763094;
    
    uint256 constant IC30x = 8912815525745351499394179119196688391932503544598568769209228156607367203899;
    uint256 constant IC30y = 860985238431007380775519923460493952035470238435223739855074097251116326211;
    
    uint256 constant IC31x = 21224837900098927332837562316691318035773274046558763846097039583862854174821;
    uint256 constant IC31y = 21042822746913005060317240297104330439571844723782690195918679695116912241630;
    
    uint256 constant IC32x = 9179419322121282895450311945850246830851130178656479449926059275579950197311;
    uint256 constant IC32y = 4891954583043843534468015537529292797250343856138720106851301690295318728606;
    
    uint256 constant IC33x = 2660509482198576518676293588476043106215095245075936115560211547469291502601;
    uint256 constant IC33y = 15706931031454227080346208853501020169075744763907828253201208884894517763782;
    
    uint256 constant IC34x = 5298825468922281134275952888288413808602458337966267966702712665613399660923;
    uint256 constant IC34y = 10085042965622829982954928942577007596734737682027016301879703395118282439883;
    
    uint256 constant IC35x = 14273368877745260344772524398926555223734621505224171918733619103053410588700;
    uint256 constant IC35y = 3633795793357716089662348958173575842650492753040167936434857224581514007457;
    
    uint256 constant IC36x = 13926716448637669092257540299210654644023651439264676188717954905031152660392;
    uint256 constant IC36y = 1991938558589377208638834203440002422837340069393625276381249819510730044904;
    
    uint256 constant IC37x = 16684255030447847871432117226362591499750474862897509921341848988594345959686;
    uint256 constant IC37y = 12380126251013477730717645072620949715543798337877164508304962824457034058133;
    
    uint256 constant IC38x = 7222626539317841362674899161489173693980034957686471866354504173060502183680;
    uint256 constant IC38y = 16296179153639714048768048811942614847304343111331001035236610896766164054630;
    
    uint256 constant IC39x = 20214089796327880760458890663666242392161787375470021992611876929315774926117;
    uint256 constant IC39y = 10005772126914014376740737725231929708705633638726988844491140731371891239352;
    
    uint256 constant IC40x = 8748474738961242727393074667927152816376181853081228777131234676703538308360;
    uint256 constant IC40y = 4166370187429475019955474697799100274438224655642827468710113779190557564319;
    
    uint256 constant IC41x = 19178932044892768279069897846039005091056869340101308652740855895567820730162;
    uint256 constant IC41y = 16988231257924832827488583091224647809144034426734711076896415994250847423347;
    
    uint256 constant IC42x = 20621194198659736522847563334540074109616979942667342758071691165431090255778;
    uint256 constant IC42y = 6711423905129946113774129466876046963812333205159346718017663285810329991695;
    
    uint256 constant IC43x = 15416099361236042350122688170653915147984217974427412549636420903251622473972;
    uint256 constant IC43y = 9420726600512412296316343772448308590418941880142809732152241469716822680817;
    
    uint256 constant IC44x = 10087929311427463830545744556245715627319218860026295347599032137643997623006;
    uint256 constant IC44y = 3337350136039114557348267104573358779776464691412498613742106808294761068935;
    
    uint256 constant IC45x = 15244723816223205457455627780040989300878352761671294956537732599106486136633;
    uint256 constant IC45y = 5753735210573043347679708762689185983937782364338108421697101884274601803111;
    
    uint256 constant IC46x = 18933044827425121571130594729293859370866436775794753573276388846513711888648;
    uint256 constant IC46y = 6177735740795796237136906064608022021364556914950733999056000371545479654213;
    
    uint256 constant IC47x = 12569563406489656836431353757451195874280920615888052462826880045887136572477;
    uint256 constant IC47y = 269170251104016790130584618792246555948171160505005630043281879039431546997;
    
    uint256 constant IC48x = 2938184716360037364418522464730835059591839931178816523171193685926164368173;
    uint256 constant IC48y = 20464075746327163268357077448971116263988241961476959526165538089357756191067;
    
    uint256 constant IC49x = 7152037383227442223506356303732572308443617532503182492862660448987836761761;
    uint256 constant IC49y = 7302052959547380986854420123600411021989772648437459668778762768724015977984;
    
    uint256 constant IC50x = 3136533076750072302401122147831282418307454169150671086191653285879577853529;
    uint256 constant IC50y = 6478545731711527023523598768790056245076696915888882042639662524463295335549;
    
    uint256 constant IC51x = 15994031278923501332244374870901020922072589753160128559475605117473747999796;
    uint256 constant IC51y = 12714044855777943367158235016853423483808532038920127690728215956216149902783;
    
    uint256 constant IC52x = 14839687929365632755835736688340709835056894648452358750947467311844602020368;
    uint256 constant IC52y = 11810826609453731930125925528624806186541040556765687236885502977057260637006;
    
    uint256 constant IC53x = 11677352192162393780622560069128195996025162948885725150388444718469359263435;
    uint256 constant IC53y = 7505001428334282834748735706502184904449852818142861323878208106784121392022;
    
    uint256 constant IC54x = 12906941464748621539395789783630772803852422418097670807977428016272807703891;
    uint256 constant IC54y = 8420025012155712606421667269741394278258118294007360874391573854308417499136;
    
    uint256 constant IC55x = 16769924047013466307575406549527714706528708754424190482416542781513157571303;
    uint256 constant IC55y = 8742367144574877376159945945140693721579605243213816449060580040025133583930;
    
    uint256 constant IC56x = 16311697532766564568216400660076261342449594625250680316207994313685604014256;
    uint256 constant IC56y = 14459635704881027838307406633953343728297099902657485661606546336588472189011;
    
    uint256 constant IC57x = 6874848848790300053883880665062191184727922643778021038384574543135892429157;
    uint256 constant IC57y = 5366415503455642378926070540814442854169626672138644107040112550094992599749;
    
    uint256 constant IC58x = 17135019340321224873188452097564093215117776610708321247166724386103388542065;
    uint256 constant IC58y = 8073586424903611489885548908272053143307741865895982553720812859704984694223;
    
    uint256 constant IC59x = 7570328482429665524547207967739889884467264116248289928677291700605245126621;
    uint256 constant IC59y = 3058931634571090293171627808464332089504503672918366595573585337782814624793;
    
    uint256 constant IC60x = 20414248696364157760642156076234891106389744610922182627100453811581437400253;
    uint256 constant IC60y = 10648319863692432962144117790034795154034669299155378597879793913253325717245;
    
    uint256 constant IC61x = 12825505872738496028829862627101129511992812008244453218033769555484181779280;
    uint256 constant IC61y = 6307444362843653737823883516937896803360683045223486569986067367035277556831;
    
    uint256 constant IC62x = 9651994352301832058364814865898524894771635708636004142989748465584707565122;
    uint256 constant IC62y = 516493411239149844349039968702201840368482256435807566827099766317904316090;
    
    uint256 constant IC63x = 21497976274252177959246207685625338195381729816485423424233653103244676879328;
    uint256 constant IC63y = 2950739200224660287089919929522379213196188831206009934176280361011566739313;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[63] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
