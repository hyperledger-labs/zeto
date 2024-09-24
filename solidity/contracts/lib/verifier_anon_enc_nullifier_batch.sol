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

    
    uint256 constant IC0x = 15463228992890913407256271912655902703204304471203583418871710110367568509017;
    uint256 constant IC0y = 6081643586730902920310484720784368541485121289118172242921785599841793039397;
    
    uint256 constant IC1x = 7690092334332803225358122531593469612638564706239742127383115275750637128544;
    uint256 constant IC1y = 4070716537409257501255053424367331199883828899205760134468805014488240593235;
    
    uint256 constant IC2x = 1897861027150832646882538023040630326718005087509077431813937643855057325512;
    uint256 constant IC2y = 1439104093149456820519872532162098266586027883053410812354650892557521752658;
    
    uint256 constant IC3x = 4247406668949246815522915881558097313801033425260638984520747823588066294010;
    uint256 constant IC3y = 384187583735544539895332388057505134919889393310645722394574257594265340544;
    
    uint256 constant IC4x = 2163280919944916722705407124486638913202715101976337577933948527523763136316;
    uint256 constant IC4y = 17743925429712862815908467894864768203059146362469259706665186071908793546304;
    
    uint256 constant IC5x = 1619258089617143478432432741785464751663918498436908219039181629518309232037;
    uint256 constant IC5y = 11630616902607787050358650172682737668169372249533372501954846248236883577037;
    
    uint256 constant IC6x = 11856397151368437471647436909385425738968114143993909218432032948582691038255;
    uint256 constant IC6y = 678272634636435534137608607645423344933204026891856980589563368261431859655;
    
    uint256 constant IC7x = 5770940534172849936200191790166968674512475692082635469024125098067660874340;
    uint256 constant IC7y = 5796891932643059731209408355543252398184249413054025674322014797701901199161;
    
    uint256 constant IC8x = 21157884469337147167484623772858155700668090233318692577599491819791268263103;
    uint256 constant IC8y = 11319817801893944559243060679771033423769978982984416308930737959593420067187;
    
    uint256 constant IC9x = 17155601633062182536973842836383359711305654711820090042777274053320592459792;
    uint256 constant IC9y = 4153339199036173911292560028271096884640710297588841704979849414084725739989;
    
    uint256 constant IC10x = 19502162444772235516642339462161346484221330878380009887837212894180467490090;
    uint256 constant IC10y = 8746377545292087029262304097721851587587533642816798045978033468894796298271;
    
    uint256 constant IC11x = 10492727340495605431811280843573770802173281509627577093132502224855941607786;
    uint256 constant IC11y = 12593957599668519647646623252624235771356540353621190049672109046663132567393;
    
    uint256 constant IC12x = 2141055855219834142007696005384065075492349785073794976665158196389003189441;
    uint256 constant IC12y = 17406300413981635438953802745917216957016698564219386571963271017518080214467;
    
    uint256 constant IC13x = 19032830625159879771752338038675350316929691880552436444519236054639916485885;
    uint256 constant IC13y = 12903015174084070036198447168709051493274452823678667961495604360873262456786;
    
    uint256 constant IC14x = 16371683632587610030576224024875254515874360648746009582599446538505985845307;
    uint256 constant IC14y = 11173673008313918399612751353743129118083339259017536663266638097162487858620;
    
    uint256 constant IC15x = 15737548200096487165947831292170304880183367558719053011425105902130220221758;
    uint256 constant IC15y = 17935613113686543895175918584771321696813538867893834513577602284559153945408;
    
    uint256 constant IC16x = 18944733370869458467936382884278952997679539994012239122340654508303854835845;
    uint256 constant IC16y = 15129624232037524523766906312590739384074339500781885555180217280630980807979;
    
    uint256 constant IC17x = 766879213842683919337084764327101390445760653210017226852735122564521980106;
    uint256 constant IC17y = 13257194366329105926979110483114146395805993555097867134185789623853915836985;
    
    uint256 constant IC18x = 466834947469548587015244622123248056190476516827510567771023410872527806519;
    uint256 constant IC18y = 19073602954069385500938225445649671911205643444983500612737255746611614950303;
    
    uint256 constant IC19x = 17648949249985332116986320075129441784946087962808100600088809464478557448096;
    uint256 constant IC19y = 21066315663090040597626054677994311826852899593331220450852631484801939023727;
    
    uint256 constant IC20x = 20154598293008989566712339828669128400118781474137050820769849877249304503719;
    uint256 constant IC20y = 15496920822463556703581064294717331871146167137627219477973885063073492653138;
    
    uint256 constant IC21x = 2324404389181201284864046287742150257907858884919451986972847726132386478888;
    uint256 constant IC21y = 18134091977179255262951024580719856195604717288045403200882669041767528019153;
    
    uint256 constant IC22x = 13221158529900749092192403410247720061249921155486754588343968542295912904556;
    uint256 constant IC22y = 5028152056563650345537782053038682532283749227333291047889444926654818553282;
    
    uint256 constant IC23x = 19361641654406595295525840785289520677449987795910033166894352349186921404440;
    uint256 constant IC23y = 10650981683931869840049161361062935794760639354500379916723750499138676334844;
    
    uint256 constant IC24x = 11148283475053323553211040486718325234959050263310938469899343323289033646909;
    uint256 constant IC24y = 3109004693780647674006249758989929090923302709028884287247288297028214451989;
    
    uint256 constant IC25x = 13228357596868509323150572957775844911612210741725650349702162165507904750898;
    uint256 constant IC25y = 6331432384044620993460078250696905421162322835257350537296378202567121643631;
    
    uint256 constant IC26x = 9536375111163305409151475098581692610659685731562165281574114090536689951418;
    uint256 constant IC26y = 9038552082961206589631129524924598934056043439597158013469625214978143001100;
    
    uint256 constant IC27x = 8844438162532508945581808751476500747305933630010310294265168458587341146748;
    uint256 constant IC27y = 12351730175630032342235309720309605330011746933984028737009670971810498581435;
    
    uint256 constant IC28x = 890093037798729429015514465180574619659335658459970475515347887554928607216;
    uint256 constant IC28y = 3321203689472727739933204766233295262326623168468132630828838742083531545396;
    
    uint256 constant IC29x = 894376188310087732920965947612568506834752896038979836462341779500867941506;
    uint256 constant IC29y = 8608004138419721497755714589979878275974393904523232633132083164800041862950;
    
    uint256 constant IC30x = 11044931439964914456344334341371494069878373560303210878419944483124170473203;
    uint256 constant IC30y = 9803427855593328173483023013452443696485604414496416903172860867880720274417;
    
    uint256 constant IC31x = 1684103584023867101860046558439190165716975237508236450519282487084361635734;
    uint256 constant IC31y = 5133408065911135276667071999828368466267845111169710299435079940536432113214;
    
    uint256 constant IC32x = 4338534039647724941082052989726012587859023977099240507207676336872464936054;
    uint256 constant IC32y = 16897374641288201732671683609162272649324322852915208569511172322936944220689;
    
    uint256 constant IC33x = 9170416470183524991008272907301201709743366647977411580114896261165534711616;
    uint256 constant IC33y = 3690044898492576264147530421921970583305121687878000452671756007226539391733;
    
    uint256 constant IC34x = 8334815801605428511890555908274200358088845436285928522753824970808649461924;
    uint256 constant IC34y = 12560518115013611619606981133430503709544765639252741401402558626147052803884;
    
    uint256 constant IC35x = 19825884431345163793705281160397189448823019129369075206515699595090927399070;
    uint256 constant IC35y = 7994765120516944787797908101755469459475652122106465411690195168496698193539;
    
    uint256 constant IC36x = 8596966023108930042949859388566908182935873370403952072939322045302182518981;
    uint256 constant IC36y = 5807387851106953848587697067446771376304295390995987291509842895574618702671;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[36] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
