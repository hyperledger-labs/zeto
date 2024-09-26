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

    
    uint256 constant IC0x = 2597671780590251694570119685565323840048843183405159335694422232267097858944;
    uint256 constant IC0y = 8213860297773598587502270259232550419091407212880698106060980975459142704915;
    
    uint256 constant IC1x = 8862483812835763900195190187644217978558523440961934857686069698277251165035;
    uint256 constant IC1y = 7652510358319732081254853215291009089945882523574369846519334872331056472570;
    
    uint256 constant IC2x = 7888217796744605716171927246027604238387016217738102223849326057462148785492;
    uint256 constant IC2y = 8576582989723476354505896974449655963516713987661765330961011770238676018217;
    
    uint256 constant IC3x = 14352528680833998697032764557955482324646413153382503495075845465567317915183;
    uint256 constant IC3y = 19243011797365702752348337725258868465391417895775931958786329833019920483153;
    
    uint256 constant IC4x = 4392487320426708391579693966075795790380185591934224629876177226656021920102;
    uint256 constant IC4y = 13082952223885280332924734169956320971361821620479520152957670710665009299216;
    
    uint256 constant IC5x = 3246410921612126522937407677617019956902523430558290131050966139863929179563;
    uint256 constant IC5y = 15810399654885178166598854163407739153721316569421450866223951195409637465167;
    
    uint256 constant IC6x = 6608448200226248204694649478827679708944271084059128867495190620836363543432;
    uint256 constant IC6y = 1469463329425024480904685533245022389379237452483964428569855536915085989870;
    
    uint256 constant IC7x = 7307852231039475112593987142383601694880236463128197701708676560849024948266;
    uint256 constant IC7y = 15825828005819521547988669529549429477219509748212340587417074460536404323121;
    
    uint256 constant IC8x = 7082876175210469881576943800412028198549838067675996862482715259243907738723;
    uint256 constant IC8y = 20866219759165505486220546499441896125892835863491955389574735982947973009001;
    
    uint256 constant IC9x = 16367296414927203597516613989590733068013952698060738405287535212048793073436;
    uint256 constant IC9y = 13100662036162133830465657628089803359747036547046363278544562928671020462939;
    
    uint256 constant IC10x = 12660953324410882204944497454942873011932420236908450607037711554496291551834;
    uint256 constant IC10y = 5017337532572709501338492356315622676676311947680125340270552472293496948209;
    
    uint256 constant IC11x = 12938017223692108736253470542300205103074687940280976163691951851236725973494;
    uint256 constant IC11y = 17569330124188420068165415153185726437478171411764985964911950185946817551407;
    
    uint256 constant IC12x = 20342630885581806890644137027056481970543735603633976578131518125105821917614;
    uint256 constant IC12y = 15056484383544158070695679930126332525674495858173628085598715222609521785187;
    
    uint256 constant IC13x = 8455788225496452961679299633801872615012410834148396636082678777338966830587;
    uint256 constant IC13y = 14667533314468679725174123240933383024760244475242830186466272876754757134870;
    
    uint256 constant IC14x = 12149567170771778292494559727410871049802426926691679765077855282315998609309;
    uint256 constant IC14y = 1380951936221823370087711818380075591504589948146383500969529833976400607862;
    
    uint256 constant IC15x = 4766352989791691182635058002456509827848802635606176367260246470124364530595;
    uint256 constant IC15y = 16021379633910943936876425379013477219651362538262135400890871107365203200691;
    
    uint256 constant IC16x = 13432698768504751724696856885735307391004439817130841678111462400792972424486;
    uint256 constant IC16y = 19500268176699315470221660540450777362459609923828512875319635638535908023564;
    
    uint256 constant IC17x = 2027106978523088520304891108191654793258486055367592742515642621734479986878;
    uint256 constant IC17y = 12885379807754498633078727887648044664952754419022086638754196996033264000769;
    
    uint256 constant IC18x = 10949220398425644397776376483790772577269629182083303688453860881073414915560;
    uint256 constant IC18y = 20057436519045729231987911965222396188122848678213106428088994494919359307386;
    
    uint256 constant IC19x = 5846485923548152593765310696533795024730896419830093371615151423977602741415;
    uint256 constant IC19y = 17772204202833804655322390479163634517799539727968468621900059788600589940328;
    
    uint256 constant IC20x = 16215609594427567394775135826335779265030042744678385760381534305280435465518;
    uint256 constant IC20y = 18603709842506682831291739646314175009181915216384941921308130259270074065385;
    
    uint256 constant IC21x = 1766058222969804186851406321305907427335207817599904620543688044203524722607;
    uint256 constant IC21y = 13804893675033551122681507240136237947277680441710440600217850520760585066138;
    
    uint256 constant IC22x = 10941193629908240647792765252351165933874237692700406745824002033868870639031;
    uint256 constant IC22y = 3638020580879185829103840161089592128597068702224187657764432052756035287255;
    
    uint256 constant IC23x = 5930952354462594760376136142156168856897650178619630953622712543360935660800;
    uint256 constant IC23y = 1039287092721675860743161800482533616450705342550210168940302819140444260018;
    
    uint256 constant IC24x = 532646474113271627018071424500519783214891032448645307389061272582944254003;
    uint256 constant IC24y = 10151057854673851550754133166208989367948300699959847868052519117382459699016;
    
    uint256 constant IC25x = 8405375250703253790117459631087585294901701344117711232998075871750664438242;
    uint256 constant IC25y = 3944328247961513119633005636272243777809959277100342011559673763007836092026;
    
    uint256 constant IC26x = 21614355317718094894664738157772558388158937098373656545906139451342893449131;
    uint256 constant IC26y = 8071511638847832054915722800013967614757521955341169310081076405458398492749;
    
    uint256 constant IC27x = 270478275418174140981268275965608765397454128234005817847677613575246346435;
    uint256 constant IC27y = 2168666035663772154819161912982184259884565651971605752352808469034945793397;
    
    uint256 constant IC28x = 19569908851449880064455947092469809211114746841722376707408325655352308844700;
    uint256 constant IC28y = 3025699621270862613925776395824335832232953797690111658313929728015843768796;
    
    uint256 constant IC29x = 2397616016443675765741599870545252815144654843924204698241664346514355482355;
    uint256 constant IC29y = 14005094129994017499220324359090683323552493484403197787371287972073964141391;
    
    uint256 constant IC30x = 1594026336486525641702314048066413763993325793300000100171229876791999089353;
    uint256 constant IC30y = 8072633066576840209208996401111739145989116649091797339956073760079554394308;
    
    uint256 constant IC31x = 941465443692266427834241213682069926914266822578025045598574216227841103683;
    uint256 constant IC31y = 2162285939012937035604048436417716678642325048065608592368777414167124309037;
    
    uint256 constant IC32x = 17755298264501538848178211159255564751361039329014714629678463389493815518413;
    uint256 constant IC32y = 5373972597904315947883222328549882023096106569825979715283040233275564684452;
    
    uint256 constant IC33x = 18102455506412198143265025688384882255364199113479575052771971652823946543361;
    uint256 constant IC33y = 10611532522259229347040295119756938634134184132433010612585681043909048550194;
    
    uint256 constant IC34x = 9287592647220739061864536287605711120641354785099018403519028816976992208810;
    uint256 constant IC34y = 5368688991717252135366170215180249655728193010657555227283514482663613267436;
    
    uint256 constant IC35x = 19759330282652380493014428586685989919377111184913674764033542113439733508101;
    uint256 constant IC35y = 2793822654429148772664656948523274725780698166747463520325079729154142634364;
    
    uint256 constant IC36x = 11049781270295565209712493670155543711476396567038998500851076991617994490106;
    uint256 constant IC36y = 11993996864162381036679383108580743566026297793935046480209203450105332505905;
    
    uint256 constant IC37x = 11286956316213496198784831587292367873435614453135297133863480708511731868507;
    uint256 constant IC37y = 15499569902989547236933665888709713545624276075502070694155608647074297062790;
    
    uint256 constant IC38x = 11623006485365493322989951720233690859710722576577484852549967707014267001110;
    uint256 constant IC38y = 9604064454128931077040373778349956271228053422158312825986387039993421951298;
    
    uint256 constant IC39x = 2464723668469969175747439301173496600708067106680738792474183669780873148058;
    uint256 constant IC39y = 5627731506388173033330722271769856914412098157257440317053576454763368750030;
    
    uint256 constant IC40x = 386775949029146918515856173542289693566462223678664899892733838474232891465;
    uint256 constant IC40y = 21843306558508533555498999953845692654015104011212021286439942440993655717111;
    
    uint256 constant IC41x = 14998380474237577930727399192140759096552055906436435270065429803038238552107;
    uint256 constant IC41y = 16246300275134921397192579770377320255339611288167554408872393937397750566904;
    
    uint256 constant IC42x = 2126752576878583697702142208053334270599109357577167069195979265172189209012;
    uint256 constant IC42y = 4244611359849526612607201560441002012851317308605825891261545861264066872978;
    
    uint256 constant IC43x = 11478497790344429290280909138615535796732148307974183201168482934125997648260;
    uint256 constant IC43y = 1580586981837574023152058865433485528026059123101773522208265717828608271288;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[43] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
