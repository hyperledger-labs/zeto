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

contract Groth16Verifier_AnonNullifierKycBatch {
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

    
    uint256 constant IC0x = 17662610428213256644813219563522053977019593238203593252026575307208745102939;
    uint256 constant IC0y = 7830505160689090090440089278934177510082686211172967217820449518829674827779;
    
    uint256 constant IC1x = 10346604293986880753701355463794882998759843061338973206428904565462396039439;
    uint256 constant IC1y = 21877736883548512965573565860735886841675382384168845769722396710288481409415;
    
    uint256 constant IC2x = 7285334413079068756573641978600211028803259798027134112035544835812253470781;
    uint256 constant IC2y = 17866920197607400586565288881695320789733000599142174155551393153570151092438;
    
    uint256 constant IC3x = 12094173611416162337842357160734417915681180979965703971651314502280295978226;
    uint256 constant IC3y = 4336939781541456769560405175733313452334883395346782866272388917787109137924;
    
    uint256 constant IC4x = 12893139129639077593856798836226766303525580094346393915138768444827551320753;
    uint256 constant IC4y = 9643885365331110367924443516560355173400296163015137597017514041264158539397;
    
    uint256 constant IC5x = 7419266347015262130402163811300949112462350104504140825550385399139680635902;
    uint256 constant IC5y = 6803787409534015455733249893239790833744853990019467147708575683362373057089;
    
    uint256 constant IC6x = 1862823323932686024396593640932517424493437193201939167019614621935108254065;
    uint256 constant IC6y = 10453107787728230175659930666158677682400831203142179228639446944333945857373;
    
    uint256 constant IC7x = 21657052927245507888665469077476773827294315722942681984779818184446803774212;
    uint256 constant IC7y = 1144056922100252222359693929550999973147532922715401285654713850353392093166;
    
    uint256 constant IC8x = 2445619981193440409765778231464156432401371937301797340627848201174961281928;
    uint256 constant IC8y = 21609178651065795954371242575766011431777589711841324585333609027312850163571;
    
    uint256 constant IC9x = 2642428202108574845241440569753489219554368099310373248264822642570571138339;
    uint256 constant IC9y = 8606178243782529634901788785054734861848259464147565131036750225908854331216;
    
    uint256 constant IC10x = 18480938949539583122193629564579456741615642536442983380411160088340117620707;
    uint256 constant IC10y = 18529840295865541058815666886572161903696457355366594477558159490888960921163;
    
    uint256 constant IC11x = 12636408345473815363684077864028446970269018773658746984798491407973546651235;
    uint256 constant IC11y = 13520780254338405634141033140843697547933948596622185538251005778124223888667;
    
    uint256 constant IC12x = 11729507187203462972145203070077736932410081151286322695685678174810360986161;
    uint256 constant IC12y = 13015012468311368245890094246568763116929434919813878023667882545543950432099;
    
    uint256 constant IC13x = 18215072169978285741216618958084616042925328390195974446650898807516175694137;
    uint256 constant IC13y = 1984971998239457461917179196314085248098609830859570392699477026448286912967;
    
    uint256 constant IC14x = 5406886929107805040595453776728203921127840142779122609888714199811015124188;
    uint256 constant IC14y = 14552032591867187397725707513338190078188051788030338427246599651562252959951;
    
    uint256 constant IC15x = 4255828817688137031115643784732586407352422694821098423235777511603109116467;
    uint256 constant IC15y = 18577399166189065943225077881935906900540528681890351061804616706202760315074;
    
    uint256 constant IC16x = 4210053272482072484277058067037592916959356297765309470225031168742032163955;
    uint256 constant IC16y = 21627917502213372129596580823404528375967541861730536175384685470465644323895;
    
    uint256 constant IC17x = 14889185361203526360857595001104916528469455892035828328631683257956572485173;
    uint256 constant IC17y = 2936885250154457447326920544222388659750238959522934937817665205054540961686;
    
    uint256 constant IC18x = 10199567289736952367832328097491394603239742191147146009298055698587442009;
    uint256 constant IC18y = 12072175957003475373759335090032092103024053829183698638712985817934917524313;
    
    uint256 constant IC19x = 5501790651389781313942424937674560396283844070101639521431886473550510293164;
    uint256 constant IC19y = 10431589653403750538224508026992474872091462706849934870619575548200040916229;
    
    uint256 constant IC20x = 7633068091070229432687385808712790224759677789664728994153466364728552058233;
    uint256 constant IC20y = 20977231476194267406143080122028938882360511239151509852744360484132865404032;
    
    uint256 constant IC21x = 4660640047249595895786142014858657816135831293207046864703674063264974819081;
    uint256 constant IC21y = 10162220350205829553353561421032903037748099385809132856525299958633254834319;
    
    uint256 constant IC22x = 6166728686622467473650026850037575400819469015508830110086213688241569142758;
    uint256 constant IC22y = 17039459999469497080782940042828515626811071582731542832697829077765504984346;
    
    uint256 constant IC23x = 12811534522228368734554124975163122963297791564884470212649458267267968509409;
    uint256 constant IC23y = 622860925200148307346536412441500061200664123289398434333291998096149060744;
    
    uint256 constant IC24x = 14577957129098557464040324998059586038650776177120765101706266230319807776128;
    uint256 constant IC24y = 3533852978802519457516798558810465709831858450063182836769700207649104776072;
    
    uint256 constant IC25x = 17289299625175941445399680091299211844756446691751949655743597297217038233241;
    uint256 constant IC25y = 13850576384074490193716841351843113442645964835316467249147888643283712811939;
    
    uint256 constant IC26x = 16710252509253846880613722286341711814359194873671831698177703637282225093753;
    uint256 constant IC26y = 1965216602649426379491347306794406373040026952622075871484630462007188544608;
    
    uint256 constant IC27x = 14798329544285611920573615808119362859842791636585941661849222806901938186721;
    uint256 constant IC27y = 11328671377353849071342437741702175801261432877846272530878009218498480440126;
    
    uint256 constant IC28x = 15805532140015816324396700145921954150151739746332710431994480604745285080988;
    uint256 constant IC28y = 10965618640489496953814098004162557454361322014529500352647158670482737355858;
    
    uint256 constant IC29x = 19920020306802990281613437137168536539920359730736161626273264455790963607518;
    uint256 constant IC29y = 14476322698683316890411695477049727571941317419568393880238555012089572655054;
    
    uint256 constant IC30x = 5909439493895700932554593202401039361992154467819335440960997190670748539547;
    uint256 constant IC30y = 12756874630327086363541682824130486736998354813540534346812188560627020504948;
    
    uint256 constant IC31x = 17913987795045334044805471750580503112706882087161238172356573243944112908138;
    uint256 constant IC31y = 4301004105494189265321475195927558252055109615821360484443973249976134639951;
    
    uint256 constant IC32x = 7033519760011410808265433656588665526821237137687551758740221477482782036779;
    uint256 constant IC32y = 9853117829963576651636655238186392877860731537315795877386027394448959212515;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[32] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
