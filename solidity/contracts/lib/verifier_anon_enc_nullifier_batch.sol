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

contract Groth16Verifier_AnonEncNullifierBatch {
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

    
    uint256 constant IC0x = 10645351421275030769212842451599777004533318201294902462005034101795836667735;
    uint256 constant IC0y = 19773846574370070068526112402756882493172867027564763871401825452271772896770;
    
    uint256 constant IC1x = 21045668564796633627967971401776840306235180091510629996956077562174112854797;
    uint256 constant IC1y = 9692641105892987460288991259626904081160606632602573786680505922597146001820;
    
    uint256 constant IC2x = 6986710375170555089687323877472514817724381470286988221636916919623639919267;
    uint256 constant IC2y = 11825153705848256829640073197891287269133258372909893963327355565129252469538;
    
    uint256 constant IC3x = 21589139179301699049569868901784946727171433740472463820916197439162935213931;
    uint256 constant IC3y = 551980383756225690231265441795287943646681755160849513598947577957901960769;
    
    uint256 constant IC4x = 7848148325988989144014232092764440426513779624118010875067911492016597507427;
    uint256 constant IC4y = 874964876333419237750792570559364811284638715362980586388785676601037939603;
    
    uint256 constant IC5x = 5030538897432365602364477809726773513224377789278422573056864982899918308435;
    uint256 constant IC5y = 6538658663213062852245653828011736921546820135242837798372228475915946407294;
    
    uint256 constant IC6x = 1134488520285628584172609693922141497292325051235162469824971135714986508423;
    uint256 constant IC6y = 13421809311905703563334091581498477650119249056168469733417655945944292140800;
    
    uint256 constant IC7x = 15809369401596210985478473064948224599188521859155115813447540322319418684429;
    uint256 constant IC7y = 748154560614039972265932322980194959340014814655278777140312658340634440738;
    
    uint256 constant IC8x = 16422634041753847419090532487213130865873369386359797042255555793689963416641;
    uint256 constant IC8y = 13345489373898517826619448768139131981126393410240491128775416736099748551986;
    
    uint256 constant IC9x = 9023891455582583354799282243974737937216662894041709294412517055346091405216;
    uint256 constant IC9y = 19721049929631439090338791564588794157023579033738842201236698580157965105980;
    
    uint256 constant IC10x = 16791613249768019763130155513839129939686345377917856464443567247489567026164;
    uint256 constant IC10y = 15270069150558256924307484622069492276980978114465458770799437465145659888704;
    
    uint256 constant IC11x = 9565236675475260845883610238852228330283848177620410368151292023129362514150;
    uint256 constant IC11y = 12882180919417442528934412844769993736456066787664071079858702514787733345580;
    
    uint256 constant IC12x = 18889158444844545745822687387379205884168164919645495138937434791246868284441;
    uint256 constant IC12y = 4463993601421177726480051615090675190432895924456563349702780067665853863063;
    
    uint256 constant IC13x = 15654824613646082563998075951610876530965463902310927076566046041401790190883;
    uint256 constant IC13y = 17897729347904120645817815694494907164306296387380224653473061731475087083629;
    
    uint256 constant IC14x = 9914952707022185044859485843755152355827023461798918762873853737142122912923;
    uint256 constant IC14y = 12223117364915343804298414875843316912398960926175366191900849476327091675443;
    
    uint256 constant IC15x = 4530178371631031025262966851421025083373895413001645547669158623799333125120;
    uint256 constant IC15y = 14847450682708930563109693216793086242583142312601249669264886719333269385228;
    
    uint256 constant IC16x = 20686192905301290185660609077917244772970221404992626008004711488059672116510;
    uint256 constant IC16y = 14265228262044037282704321826983234216621387716914500339084109632125396447817;
    
    uint256 constant IC17x = 17184296579665233138664538393593533408797018385395879255045965137088911002633;
    uint256 constant IC17y = 5794545279126857667791925152005171752799892805442052280969080353648295951877;
    
    uint256 constant IC18x = 12283677454922856060911771154661643414034804829779437509272866105959185262393;
    uint256 constant IC18y = 11418437498830438374304711347669336909061511813254033588733923242783698973381;
    
    uint256 constant IC19x = 233410113256358208167749654377889109662917637067643192371866364989155032597;
    uint256 constant IC19y = 12489787345918568886208972254163440419069461589228081734396525205615115646823;
    
    uint256 constant IC20x = 19922851833540760840323478915538105324832288698966396321587996988043948108076;
    uint256 constant IC20y = 10009437256472029856043218169660264477908251912118684527903236010503598851905;
    
    uint256 constant IC21x = 8576754828850430389792536700359043190882873416990199648102622011137214624344;
    uint256 constant IC21y = 4068078849091371850291208205320805744942525044974109855286604207667579180916;
    
    uint256 constant IC22x = 19720349134069389994319317515114599480576251259055426609291868076253917408190;
    uint256 constant IC22y = 17491915401609613751947047987004497358908114555334188876708093723103785538658;
    
    uint256 constant IC23x = 7234542443296093769067891602273037388908886094779444443372875052814418213738;
    uint256 constant IC23y = 2298362372262249126601288098107811726732535043084050139693826893330484043384;
    
    uint256 constant IC24x = 15208114325793531028606742636462558162754988632195033802710190832208321334839;
    uint256 constant IC24y = 11228155327966805755480600454789239990152846144317355172501847758906396211607;
    
    uint256 constant IC25x = 10754029893239883996357951951628952208784365734832249102641651831368516446554;
    uint256 constant IC25y = 1512088372644426222104577554197067771438352753703259964417078053825961713151;
    
    uint256 constant IC26x = 8965801610689595002595405380643107571231801526473821486939465596524456163563;
    uint256 constant IC26y = 1990575800156351430249196431321287695225190689306325346684717577132046431696;
    
    uint256 constant IC27x = 658799463109049530635389082698553628347185965072273064330390643365460948483;
    uint256 constant IC27y = 13405677562890064873561226033606712934771098608476724815623119529809072464467;
    
    uint256 constant IC28x = 4670655359096776733553081707580682502588844748490083471633629023138096830770;
    uint256 constant IC28y = 6488838101003408268756670018808136583339021091391323196295144950220700805022;
    
    uint256 constant IC29x = 1180261368895845469822817411490892166215039187401084649877621394704393314521;
    uint256 constant IC29y = 1595293418801543000842631962609502350103032468055613957656853561575554047309;
    
    uint256 constant IC30x = 5725599681638513867016777243382848042025457023850387857074973591421703130467;
    uint256 constant IC30y = 4748358959923203058463512303427588038076292680303181970622439573870368895155;
    
    uint256 constant IC31x = 2831823426676598609658562094849647686826880490121941019646351323030466610253;
    uint256 constant IC31y = 21281681591843671212111112787927911584393264086933269718285923299781025930183;
    
    uint256 constant IC32x = 15628714637902002845692835315528619606830497872595777646425845531920921400266;
    uint256 constant IC32y = 11029956528040516226392608549108249971969362564800280651245935215718627917626;
    
    uint256 constant IC33x = 9741166931188394303452044647985267874563858336310297156862728995780923050539;
    uint256 constant IC33y = 6856253999079830481815920937335629800513686843192893986891527925012405183234;
    
    uint256 constant IC34x = 5340412578893639027320892120181771247600027415070143114023481697402168083877;
    uint256 constant IC34y = 9878785258591337618411677581553129429961809222004088126614464671926218373919;
    
    uint256 constant IC35x = 7830802881076272422242002885628397049146608767124814001915399705546480478018;
    uint256 constant IC35y = 10271233937081179488796109492342220509920605765038327265765714123716270784734;
    
    uint256 constant IC36x = 20568695072909926090785472199131742449061946847819876557253030954218241038760;
    uint256 constant IC36y = 8090253717659426926034994325565773534226744105745394292903914691628468035246;
    
    uint256 constant IC37x = 4360593488861012363063576337873090659969383301282071100663777774474540251412;
    uint256 constant IC37y = 13508974920574837809802168852314929870859132568397534363560268700023166572893;
    
    uint256 constant IC38x = 8168819567987017334417818056594040000893675129075330554707633927655599399207;
    uint256 constant IC38y = 21554364355211946772896514721212726528098242209156762958769350026161400782521;
    
    uint256 constant IC39x = 9076190532075581219228461167043852103071119206540332157010085453015207330636;
    uint256 constant IC39y = 3356337988822620456051098873656377101773884966760489577022762536150452531973;
    
    uint256 constant IC40x = 1738890537986340641563232846815778379914302770951790146367744788596111766203;
    uint256 constant IC40y = 11680744043960758529481344360760385090686529128760223022815305468253390838058;
    
    uint256 constant IC41x = 11032519278078035374450371251480117616307375430434303273522473430480466273898;
    uint256 constant IC41y = 11759444777541376334762679081562192846943888334241598365174416412382416775371;
    
    uint256 constant IC42x = 975484287630296320123562370594436328585623119435685348496746244589960426282;
    uint256 constant IC42y = 16306932306324030391394601010083896325087656834393554589950134417361741693871;
    
    uint256 constant IC43x = 20799943769577155751147517300197228323261634403323343777907580029956076446788;
    uint256 constant IC43y = 1582030258433952612426737479742105317880911936406371291174661209030848912117;
    
    uint256 constant IC44x = 3908730706265324626495762736382090512637335740407382692274982098972015427593;
    uint256 constant IC44y = 5154443680021960787510375550446891195833558907011270847949752866056543144710;
    
    uint256 constant IC45x = 20422043385069297179239469706704066046244123188430264658044861269153295485013;
    uint256 constant IC45y = 17509293807050079024428031793068504906531529399685577643741547856609753098825;
    
    uint256 constant IC46x = 19377904175261504733149287710614929387142186881520208018631868270226707238243;
    uint256 constant IC46y = 19584370567070657365983874417025970012162180256418183204070215232820650535367;
    
    uint256 constant IC47x = 15124599472592999515315943698451703704951186669815756069476650692212183790929;
    uint256 constant IC47y = 21398072253702860808041845648657417165878223226624391728708768110703783597013;
    
    uint256 constant IC48x = 4079937364778920306442594024315627391052523545523540009281519905055199997783;
    uint256 constant IC48y = 10201888942110078166950344165524145021781867737465046769820965073997280386548;
    
    uint256 constant IC49x = 19356092471412258141029087355553408270673707906855194680708731257168363831435;
    uint256 constant IC49y = 1061038648054283783341854542745595029053821005560616425434165472291015715453;
    
    uint256 constant IC50x = 21343028396534167722522087334655271551240992456400214147277830321036266408423;
    uint256 constant IC50y = 11846669440179039761703317955616648733553305301080432399933270821945580221008;
    
    uint256 constant IC51x = 10292521103864911829516118733430078449161529689024076122421368624813287114332;
    uint256 constant IC51y = 5262830170148138781879618635618998979151463825944890441891322091482955700449;
    
    uint256 constant IC52x = 20153037745608603454973876932832386367398863709960474763581636423278843777558;
    uint256 constant IC52y = 8131864189330604204685933794116391572936378578510887245069112518537895076359;
    
    uint256 constant IC53x = 17187738837796036200075504264487161589801857077194488751149858577446279014274;
    uint256 constant IC53y = 12080362734230497576274130333255296516249494013550225996752358008099406447652;
    
    uint256 constant IC54x = 11847067467241475596668453029782243247363206460914528357997382225539958278828;
    uint256 constant IC54y = 21086520617081063638758857193949011421080843371947185288143683110611184659837;
    
    uint256 constant IC55x = 5996420344908801778003389639638044198976138220876658841634453433483910911772;
    uint256 constant IC55y = 1497970572715261788820528550447484475853291992758033288069899941602871818952;
    
    uint256 constant IC56x = 4707714975194514186283567202803559015209693536722913628673628779812487347123;
    uint256 constant IC56y = 8107985637246170799012634655180246560278288486829178920536350781113786554058;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[56] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
