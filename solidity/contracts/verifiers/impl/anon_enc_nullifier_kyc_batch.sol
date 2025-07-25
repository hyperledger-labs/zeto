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

contract Verifier_AnonEncNullifierKycBatch {
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

    
    uint256 constant IC0x = 4288616686482057912020194993920815898078706030230787047623298302181604412487;
    uint256 constant IC0y = 13650095453391764610736023145057037789006440818085590867383757301012442051849;
    
    uint256 constant IC1x = 12007155892400112231008616365921024049916681580947819811596622224240275944062;
    uint256 constant IC1y = 15995726877321474040812371691220639228426029780874697733933039968215879118232;
    
    uint256 constant IC2x = 20391629972855054238469058324475880512363416332441400913679847982784336297704;
    uint256 constant IC2y = 17510578894907457672922238075231163289873901939772667867310525449448907077687;
    
    uint256 constant IC3x = 21881534507916091214081850240092133981900965778556714060528439620522909075315;
    uint256 constant IC3y = 17481979902172197384237638751723134442247737955184971642573956374353357154744;
    
    uint256 constant IC4x = 4083967816444955307442658371451520867090747762515698852713166618254688527360;
    uint256 constant IC4y = 20448786754682240367309110494864463460849454782735991643527618590817966727752;
    
    uint256 constant IC5x = 2515376489936435184861059904057492201886057806608304808796914620065799280203;
    uint256 constant IC5y = 21571254837834411587188882431016669018677084985431209984643130242612170366428;
    
    uint256 constant IC6x = 1243636076797886429159625696346898983749966181674798915004935505726652043604;
    uint256 constant IC6y = 5194613810074740844723247997739099915066302247321880788501401903209352248919;
    
    uint256 constant IC7x = 562217275445586453224147615905929706059470613527398427725043029809677657729;
    uint256 constant IC7y = 4166493418319826027907904254208052300802013526593917772273090026759693405557;
    
    uint256 constant IC8x = 19417912096955806366758384290763270290826690705836169308289782206912316911362;
    uint256 constant IC8y = 13118433209398608467786737009525436841565007093855005960758102270268282498714;
    
    uint256 constant IC9x = 19678970924872955017630800655194878713529128819199393950678012324623248641601;
    uint256 constant IC9y = 91170593668329719815090174335182421535915460930791441596959390489350361658;
    
    uint256 constant IC10x = 14516184203920526979497830214956301302156626637746172744385172317512737278264;
    uint256 constant IC10y = 14573459707933794019744585774892768680430916363155740439731025124859568776314;
    
    uint256 constant IC11x = 1160692252973853744714051683691710376240968065389954920560800380931086206070;
    uint256 constant IC11y = 18571158822393921501447654530948701187191070937011124218439842432140201162204;
    
    uint256 constant IC12x = 12938519960949768716133720541512471498538881107780383998049678959176375339606;
    uint256 constant IC12y = 6176130329089878631366036215409668483989529929963648587239685236098263802042;
    
    uint256 constant IC13x = 17650921412964671516573699871707388489281194705224875208615527112805354158527;
    uint256 constant IC13y = 2468984830719376531789411201929194143324622567764551538817426746728956246446;
    
    uint256 constant IC14x = 19971208031194769053693291031004149096135375413958541322136025171411868508716;
    uint256 constant IC14y = 5120875656119571155749635378282044082203678178208945582637053148287197605553;
    
    uint256 constant IC15x = 16506393982975441087891709298112770732829556671713017039148714473088781154042;
    uint256 constant IC15y = 7956066781069737266962446612252547665312004677770096898975538023250737318704;
    
    uint256 constant IC16x = 52867160097476884171986796188356174690915658510430638710806467902139380394;
    uint256 constant IC16y = 20662680660165290261620301759700628644467794464070090751481374701943704219268;
    
    uint256 constant IC17x = 15799322838025313171802621448314690399076238186743626707557437560018906916431;
    uint256 constant IC17y = 10724995173230372193754448563327761745371336929200238769469681966884497021933;
    
    uint256 constant IC18x = 6401207205527901169256999744791825860530648411357853256229674881610092573828;
    uint256 constant IC18y = 12442708461147220683973353526951331157109983982177870212614211753301093454432;
    
    uint256 constant IC19x = 7633799238687040182074049163996256745383700638998920327538849488299339655313;
    uint256 constant IC19y = 17107091568112167966874748970140733722396936653256215503762919736431008542453;
    
    uint256 constant IC20x = 2907170463661735209550634356440599134593590199194476795616376742411682871958;
    uint256 constant IC20y = 8326601118978058891705261774158220871955761306493722300220678253423360495753;
    
    uint256 constant IC21x = 231108963260766102341172763590024383277113222910039602624375519127113404563;
    uint256 constant IC21y = 7934672699444530735062269005638193995796376878425272996141888827988498724589;
    
    uint256 constant IC22x = 20068241590861849853002816323902395329140580944611521122186295640847925610318;
    uint256 constant IC22y = 21733299185847956256546341222004242501942108974730697135871244767560221038475;
    
    uint256 constant IC23x = 17804478155886670191771068385592962767044091016192415135810617328907221266090;
    uint256 constant IC23y = 18292886829725320709990058375511284842495864057196377834118314024964976172933;
    
    uint256 constant IC24x = 9918820821787981702258431080854663884118182212372825586018193082263005867127;
    uint256 constant IC24y = 17451697284016879319456112174455731083229402881709201609596352443936373819459;
    
    uint256 constant IC25x = 12549027747307639628209167894619430208570379796658174614241487214271607664150;
    uint256 constant IC25y = 7543984536341077310973514363747100866587304568284177436240262615042425624478;
    
    uint256 constant IC26x = 5569807283441770764653792896069179966705015615635472269240797340184250623025;
    uint256 constant IC26y = 7280470974477792552866259329294583525159512276993454584193646641092326850480;
    
    uint256 constant IC27x = 6232650489451458208473622097636589661204308259089308027740704234479486196190;
    uint256 constant IC27y = 15654959478532346532206636505848097223267825924994698295836955075292476536603;
    
    uint256 constant IC28x = 13699692482559934566286555424496380698014809664422395349352361550399489230581;
    uint256 constant IC28y = 20909172908198948966361905418883361707929945749194388091955643023739764382845;
    
    uint256 constant IC29x = 19510302874850859206359080289165954276355471620012810038678947286874543675139;
    uint256 constant IC29y = 4602830126702401642951392427476570462233378535886659334450679489407969083945;
    
    uint256 constant IC30x = 2311374478838411176277031764646909685663706745421811474000678816109207856752;
    uint256 constant IC30y = 18117907090468655734370036760618724633792210917368894365516028221198398982342;
    
    uint256 constant IC31x = 18818910120105579817308555125512129101087908329587287079475605731760151716071;
    uint256 constant IC31y = 21377928263953160687356596826698533153664254011849257303602125909867073112024;
    
    uint256 constant IC32x = 2155375796882881420515744752538662509484296300715454693288189200083365280433;
    uint256 constant IC32y = 1745331249601993579487517682975403575492171759255048465097243941567075131990;
    
    uint256 constant IC33x = 14178782041208377830179887973296691598854961822856613353944137937739841267415;
    uint256 constant IC33y = 2691481987934270687061111505154325988689961408660579539285072255205974133504;
    
    uint256 constant IC34x = 16030415697395764630905092684379141947773982681848411794979068201948239906576;
    uint256 constant IC34y = 3692103663971359993177539550452998802801995485258106496960842275708206409523;
    
    uint256 constant IC35x = 9388640279741235776037677982997843382805278889142823627643749264463579083999;
    uint256 constant IC35y = 21722699800531546903470532896523852160403846410714546058066037046124339369981;
    
    uint256 constant IC36x = 5319251433466811245166939783158380332530390193369431282401471715265687046321;
    uint256 constant IC36y = 18165246623426215224363959578152144724886142216006046426467612726687298752653;
    
    uint256 constant IC37x = 3868960393520420738864072886881635449022348498410309276741579400845629236816;
    uint256 constant IC37y = 17361065177865383636319210823603807129741207930928025476262355734568390727886;
    
    uint256 constant IC38x = 13739569041059916037191033862132279738475151191885969679426063820530573646581;
    uint256 constant IC38y = 13324728411849280664849655952131904704970955758696606947761946081112081063108;
    
    uint256 constant IC39x = 8590103036198377978879642561916621394450819252773024779940241460407568905099;
    uint256 constant IC39y = 19022975075868432134454680815823255154795434682478301487867081098845626442054;
    
    uint256 constant IC40x = 20545056621697322326378509747082014094839955554946783820884661111996102189321;
    uint256 constant IC40y = 18504235998000760431843961750363870684238744309409774988908254249437918145785;
    
    uint256 constant IC41x = 3834963826482043025449300780286599542902636733085816988665897193568778117826;
    uint256 constant IC41y = 6905889353617778674822676194552574470861682427318103492101386962578767435275;
    
    uint256 constant IC42x = 2573943302953541318836874093369645520128199810803967675037493076702032416308;
    uint256 constant IC42y = 17661339343223563076003314550154372251629097887428527519433047834585503542213;
    
    uint256 constant IC43x = 5970748928249439243027975030429234628371119839967376922903183139078682407122;
    uint256 constant IC43y = 9883314903388027750877399602177180696609817014117512907721003346213169605269;
    
    uint256 constant IC44x = 16760151605115771871458739605621049934885308973543924200545904125218225973376;
    uint256 constant IC44y = 5872230398312108774175468869672049818831575241352956396408888414200725377270;
    
    uint256 constant IC45x = 7960631730082516293325501022035237114185068454734547818862249256268524896109;
    uint256 constant IC45y = 14981509664889426004364823918147347786815522555151252851040724485971842130698;
    
    uint256 constant IC46x = 12999873570261772604327076425047510203411416199458618156792289108970120138424;
    uint256 constant IC46y = 3940713041202394602652392713899100088723168796483912955972377377824252946697;
    
    uint256 constant IC47x = 6550932948155941024957450387800242102587741984299816887572715742543892455308;
    uint256 constant IC47y = 9921213941655632726156259644339152581419826050584334887412242499339739982885;
    
    uint256 constant IC48x = 8199844339063906842392758958339748487443711053059966972064785694207096404912;
    uint256 constant IC48y = 11243381431180506120740823029147425941904801577150637016708175110874918566209;
    
    uint256 constant IC49x = 15361740057333786858168014200427390922860344036284315849819956276706683868165;
    uint256 constant IC49y = 8320747208868333732301559277117981117500128445366764500244002202779624380291;
    
    uint256 constant IC50x = 18357470654486095312795840582896045011252967604371158277416585703647860860288;
    uint256 constant IC50y = 13736317246196457056914427930607619362474444254841497867950021800682574564508;
    
    uint256 constant IC51x = 17455674229025180963179375029613836931092133786546075907010944869231802303377;
    uint256 constant IC51y = 11037175483438810991665798022603979738673611275009460916213889346073149266263;
    
    uint256 constant IC52x = 14502506959407498666661434669900513110996639283262611711935085339014298106579;
    uint256 constant IC52y = 11337110484532068346106090685005122421475505502077747256097649086943883474299;
    
    uint256 constant IC53x = 6565229750063639589502019806653564488740162282835146869802508788010147171273;
    uint256 constant IC53y = 17650232947016360015223522713343377062176123967393919827399546324956488123710;
    
    uint256 constant IC54x = 13625582684455857725326933113414869277515974616982736801626111057730937226197;
    uint256 constant IC54y = 13577143576239729419635826404305148518619922967896970272960381499345215060820;
    
    uint256 constant IC55x = 13977884606660240362826316641870164191088016635462629286619580561056740525242;
    uint256 constant IC55y = 8968946310608457876716913355595762350073446096878646729244659499488521383589;
    
    uint256 constant IC56x = 234924127096600280544349471346003125154343535453879293972825586739362609996;
    uint256 constant IC56y = 12469569156540016250275090857518195487437385297166139113325515361533198952415;
    
    uint256 constant IC57x = 2817377482423748162688627027230565900202028125027540099993389148209536000247;
    uint256 constant IC57y = 19714065052892453612172911944295795311705963794819206326014418989898948685082;
    
    uint256 constant IC58x = 19312925013229432518874423195170217597301407826655295050519031776735941201802;
    uint256 constant IC58y = 19745219899141653481475455169446983489857238667362019840168173456115377854945;
    
    uint256 constant IC59x = 21622058598416738052905111391729438346739436286144013679906209762577432977802;
    uint256 constant IC59y = 11216008413865216127539533818253233129105640467808888754386608618347130676699;
    
    uint256 constant IC60x = 21079541496306969844289633092423033429293443064223453625622220174387513264306;
    uint256 constant IC60y = 9814412140061961861787444437796759799094302856517502657251268584818164656075;
    
    uint256 constant IC61x = 20311950328713433413371245467752288521462781597132375717984856175375159539172;
    uint256 constant IC61y = 16576936377959938864955255166055014906526153565277269184105313471600185959285;
    
    uint256 constant IC62x = 18614099034572144348508311081172864933521953020248378966689443623806426304257;
    uint256 constant IC62y = 2325062743243857751793186897909788360203172990656632274931369661246606520392;
    
    uint256 constant IC63x = 16432190925352277980220927709428750237144715789428319203350867517148309076654;
    uint256 constant IC63y = 11618322360038174670835025139458728164820330022347791981536533915333646783420;
    
    uint256 constant IC64x = 2471492042916714850780589247163561203250212393069613601559889559990549985261;
    uint256 constant IC64y = 6335474836287935609899836547118534900577609903114600988883487971579988869673;
    
    uint256 constant IC65x = 2211793765057503835422511838033335355000293200515359143602577049718842646295;
    uint256 constant IC65y = 6863143054512952680744987296880968738178441697349550000195420514709666522022;
    
    uint256 constant IC66x = 16789197597940383878092945813247244165687956465476349876488425641818274115905;
    uint256 constant IC66y = 20618549329751735849608354611206298451555374549094357796485606491936487891823;
    
    uint256 constant IC67x = 14568917144572950442895036161776571898682363764798058702128680475239125923874;
    uint256 constant IC67y = 4221098650801269050636924583658237879761346306788651828442041203533302623087;
    
    uint256 constant IC68x = 812786076266490736550130487398338899448836170654910241272754886828989423660;
    uint256 constant IC68y = 20963638055683632822385496720014016375183668530433903723770524686325763154415;
    
    uint256 constant IC69x = 14982944107471446181458812953084260539728837010329499462204862467172057287971;
    uint256 constant IC69y = 18687269036938890794106954116867663021292745664016175085506119336191338536922;
    
    uint256 constant IC70x = 10298070133244839904489090100438658099366041187550273540250845844882917705006;
    uint256 constant IC70y = 3847224785778544643344284560351243208966536377947276940413613228458161073398;
    
    uint256 constant IC71x = 13185078496129963029054883824389218987415953125083276693576858231550967370069;
    uint256 constant IC71y = 744008681765663189807994776982284972196874809149427281915982692019988394549;
    
    uint256 constant IC72x = 7443052243769958980273392495859762272506067909002611571666653663556531916207;
    uint256 constant IC72y = 18450096883439549027354721862039736403215540829312100236728960875904302268054;
    
    uint256 constant IC73x = 20681779938966383748339678093689981801472426815200586546570887040690605107720;
    uint256 constant IC73y = 6248293957910229824073811627858148555792962718512276353074094270531093178220;
    
    uint256 constant IC74x = 16080653836491307800139952753497028118903699978357748533541969110218761039935;
    uint256 constant IC74y = 19891567537003736602264922499109331059699693784178328912940487897687674001314;
    
    uint256 constant IC75x = 10957524738482415818683577309759264587769312279533269393857425396559573967315;
    uint256 constant IC75y = 6517694634996611996791088363726723878659782132897035129643844600575873656026;
    
 
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
