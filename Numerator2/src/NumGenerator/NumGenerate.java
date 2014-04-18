package NumGenerator;
import java.util.*;
import OracleConnect.SQLRequest;
public class NumGenerate {

	//��������� ����� �� ���
	private boolean isWord(char symbol) {
		//������� ���������
		ArrayList<String> c = new ArrayList<String>();
		//������� �����
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		c.add("�");
		//���������� �����
		c.add("A");
		c.add("B");
		c.add("C");
		c.add("D");
		c.add("E");
		c.add("F");
		c.add("G");
		c.add("H");
		c.add("I");
		c.add("J");
		c.add("K");
		c.add("L");
		c.add("M");
		c.add("N");
		c.add("O");
		c.add("P");
		c.add("Q");
		c.add("R");
		c.add("S");
		c.add("T");
		c.add("U");
		c.add("V");
		c.add("W");
		c.add("X");
		c.add("Y");
		c.add("Z");
		String sSymbol = "";
		sSymbol += symbol;
		if(c.contains(sSymbol)) return true;
		else return false;
	}
	
	//��������� ����� �� ���
	private boolean isNumber(char symbol) {
		//������� ���������
		ArrayList<String> c = new ArrayList<String>();
		c.add("0");
		c.add("1");
		c.add("2");
		c.add("3");
		c.add("4");
		c.add("5");
		c.add("6");
		c.add("7");
		c.add("8");
		c.add("9");
		String sSymbol = "";
		sSymbol += symbol;
		if(c.contains(sSymbol)) return true;
		else return false;
	}
	
	//��������� ���������� �� ���
	private boolean isSpecificSymbol(char symbol) {
		//������� ���������
		ArrayList<String> c = new ArrayList<String>();
		//�����������
		c.add("-");
		c.add("_");
		c.add(".");
		c.add(",");
		String sSymbol = "";
		sSymbol += symbol;
		if(c.contains(sSymbol)) return true;
		else return false;
	}
	//������������� ��� ��������� ������ ��� ����
	public String ExplodeOBOZ(String OBOZ) {
		int i=0;
		boolean SecondSectionFound = false;
		String PREFIX="";
		String NUMPART="";
		String POSTFIX="";
		String FIRST = "";
		String SECOND="";
		String THERD="";
		int index=0;
		//��������� ��� � ������� �������
		OBOZ = OBOZ.toUpperCase();
		//���-000    -0000000�-00
		//XX-000-000-0000000X-00
		
		//--------------------------------------------------
		//               ��������� ��������
		//--------------------------------------------------
		PREFIX += OBOZ.charAt(index);
		index++;
		PREFIX += OBOZ.charAt(index); //������� ��
		index++;
		while(isWord(OBOZ.charAt(index))){
			PREFIX += OBOZ.charAt(index);
			index++;
		}
		if(isSpecificSymbol(OBOZ.charAt(index))){
			//XX- ��� ���-
			PREFIX += OBOZ.charAt(index);
			index++;
			//��������� � ������� ������ ������ -000
			while(isNumber(OBOZ.charAt(index))){
				PREFIX += OBOZ.charAt(index);
				index++;
			}
			if(isWord(OBOZ.charAt(index)) && isSpecificSymbol(OBOZ.charAt(index + 1))){
				//��-111�-
				//���� ����� ������ ���� ����� ��������� ��
				PREFIX += OBOZ.charAt(index);
				index ++;
			}
			//��������� ��� ���� -
			PREFIX += OBOZ.charAt(index);
			index++;
			//��������� ������ ���� ������� ������. ���� ���� 7 �� ���� ��� ������ ������ -000-
			SecondSectionFound = false;
			for(i=0;i<7;i++){
				if(isSpecificSymbol(OBOZ.charAt(index+i))) SecondSectionFound = true;
			}
			if(SecondSectionFound){
				//��� ���� ������ ������ -000- ��������� �� � �������
				while(isNumber(OBOZ.charAt(index))){
					PREFIX += OBOZ.charAt(index);
					index++;
				}
				//��������� ��� ���� -
				PREFIX += OBOZ.charAt(index);
				index++;
			}	
		}
		//--------------------------------------------------
		//            ��������� ������� �����
		//--------------------------------------------------
		for(i=0;i<7;i++){
			NUMPART += OBOZ.charAt(index);
			index++;
		}
		//--------------------------------------------------
		//            ��������� �������
		//--------------------------------------------------
		while(index < OBOZ.length()){
			POSTFIX += OBOZ.charAt(index);
			index++;
		}
		//--------------------------------------------------
		//             �������� ����� XX
		//--------------------------------------------------
		FIRST += NUMPART.charAt(0);
		FIRST += NUMPART.charAt(1);
		//--------------------------------------------------
		//            �������� ����� XX2
		//--------------------------------------------------
		SECOND += NUMPART.charAt(2);
		SECOND += NUMPART.charAt(3);
		//--------------------------------------------------
		//            �������� ����� XXXX
		//--------------------------------------------------
		THERD += NUMPART.charAt(4);
		THERD += NUMPART.charAt(5);
		THERD += NUMPART.charAt(6);

		//�������� ������� ������������� �����
		String str3 = PREFIX + " " + FIRST + " " + SECOND + " " + THERD + " " + POSTFIX;
		return str3;
	}
	
	//������������� ��� ��������� ������ ��� ������ ����
	public String GenerateNumbers(String OBOZ) throws Exception {
		//������ ������ ������������ �� ��
		ArrayList<String> UsedNumbers = new ArrayList<String>();
		String OBOZFromDatabase;
		//���������� ��� ���������� ������
		String delimiter = " ";
		String[] temp;
		String ExplodedOBOZ="";
		//--------------------------------
		String ResultNumbers="";
		String GenOboz="";
		String GEN_OBOZ_FIRST_NUM="";
		String GEN_OBOZ_SECOND_NUM="";
		String GEN_OBOZ_THERD_NUM="";
		String OBOZ_PREFIX="";
		String OBOZ_FIRST_NUM="";
		String OBOZ_SECOND_NUM="";
		String OBOZ_THERD_NUM="";
		String OBOZ_POSTFIX="";
		int i,j,ii,jj;
		int plus_zero_count;
		//��������� ������
		ExplodedOBOZ = ExplodeOBOZ(OBOZ);
   		temp = ExplodedOBOZ.split(delimiter);
   		OBOZ_PREFIX = temp[0];
   		OBOZ_FIRST_NUM = temp[1];
   		OBOZ_SECOND_NUM = temp[2];
   		OBOZ_THERD_NUM = temp[3];
   		if(temp.length == 5) OBOZ_POSTFIX = temp[4];
   		 else OBOZ_POSTFIX = "";
   		//System.out.println("INFO: " + OBOZ_PREFIX);
   		//System.out.println("INFO: " + OBOZ_FIRST_NUM);
   		//System.out.println("INFO: " + OBOZ_SECOND_NUM);
   		//System.out.println("INFO: " + OBOZ_THERD_NUM);
   		//System.out.println("INFO: " + OBOZ_POSTFIX);
		//�������� ������ ������������ �������
   	    SQLRequest sql = new SQLRequest();
   	    sql.GetAllOboznachenieFromCurrentOboznachenie(OBOZ_PREFIX, OBOZ_FIRST_NUM);
   	    while(sql.rs.next()){
   	    	OBOZFromDatabase = sql.rs.getString("OBOZ_PREFIX") + sql.rs.getString("OBOZ_FIRST_NUM") + sql.rs.getString("OBOZ_SECOND_NUM") + sql.rs.getString("OBOZ_THERD_NUM") + sql.rs.getString("OBOZ_POSTFIX");
   	    	OBOZFromDatabase = OBOZFromDatabase.trim();
   	    	UsedNumbers.add(OBOZFromDatabase);
   	    }
   		if(OBOZ_SECOND_NUM.equals("00") && OBOZ_THERD_NUM.equals("000") && ((OBOZ_FIRST_NUM.equals("00")) || (OBOZ_FIRST_NUM.equals("01")))){
   			//���������� ������ ������� �����
   			for(ii=0;ii<100;ii++){
   				GEN_OBOZ_FIRST_NUM = Integer.valueOf(ii).toString();
				//������� ������� ��� ����� �����
				plus_zero_count = 3 - GEN_OBOZ_FIRST_NUM.length();
				//��������� ��������������� ����� ������
				for(jj=1;jj<plus_zero_count;jj++){
				GEN_OBOZ_FIRST_NUM = "0" + GEN_OBOZ_FIRST_NUM;
				}
				//��������� ��������� ������
   				for(i=1;i<100;i++){
   					GEN_OBOZ_SECOND_NUM = Integer.valueOf(i).toString();
   					//������� ������� ��� ����� �����
   					plus_zero_count = 3 - GEN_OBOZ_SECOND_NUM.length();
   					//��������� ��������������� ����� ������
   					for(j=1;j<plus_zero_count;j++){
   					GEN_OBOZ_SECOND_NUM = "0" + GEN_OBOZ_SECOND_NUM;
   					}
   					//��������� ��������� ������
   					if(OBOZ_FIRST_NUM.equals("00"))
   					 GenOboz = OBOZ_PREFIX + GEN_OBOZ_FIRST_NUM + GEN_OBOZ_SECOND_NUM + OBOZ_THERD_NUM + OBOZ_POSTFIX;
   					else
   					 GenOboz = OBOZ_PREFIX + OBOZ_FIRST_NUM + GEN_OBOZ_SECOND_NUM + OBOZ_THERD_NUM + OBOZ_POSTFIX;	
   					//��������� � ������ ����������
   					if(!UsedNumbers.contains(GenOboz)) ResultNumbers = ResultNumbers + GenOboz + " ";
   				}
   			}
   			return ResultNumbers;
   			
   		} else
   		if(OBOZ_THERD_NUM.equals("000")){
   			//���������� ������ ��������� �����
   			for(i=1;i<1000;i++){
   				GEN_OBOZ_THERD_NUM = Integer.valueOf(i).toString();
   				//������� ������� ��� ����� �����
   				plus_zero_count = 3 - GEN_OBOZ_THERD_NUM.length();
   				//��������� ��������������� ����� ������
   				for(j=0;j<plus_zero_count;j++){
   					GEN_OBOZ_THERD_NUM = "0" + GEN_OBOZ_THERD_NUM;
   				}
   				//��������� ��������� ������
   				GenOboz = OBOZ_PREFIX + OBOZ_FIRST_NUM + OBOZ_SECOND_NUM + GEN_OBOZ_THERD_NUM + OBOZ_POSTFIX;
   				//��������� � ������ ����������
   				if(!UsedNumbers.contains(GenOboz)) ResultNumbers = ResultNumbers + GenOboz + " ";   				
   			}
   			return ResultNumbers;
   		} else
   		//������� � ��������� ����� ����� �����, ���������� ������ ������	
   		return "";
	}
	
	//������������� ��� ��������� ������ ��� ������������� ����
	public String GenerateNumbersForExistingUZEL(String OBOZ) throws Exception {
		//������ ������ ������������ �� ��
		ArrayList<String> UsedNumbers = new ArrayList<String>();
		String OBOZFromDatabase;
		//���������� ��� ���������� ������
		String delimiter = " ";
		String[] temp;
		String ExplodedOBOZ="";
		//--------------------------------
		String ResultNumbers="";
		String GenOboz="";
		String GEN_OBOZ_FIRST_NUM="";
		String GEN_OBOZ_SECOND_NUM="";
		String GEN_OBOZ_THERD_NUM="";
		String OBOZ_PREFIX="";
		String OBOZ_FIRST_NUM="";
		String OBOZ_SECOND_NUM="";
		String OBOZ_THERD_NUM="";
		String OBOZ_POSTFIX="";
		int i,j,ii,jj;
		int plus_zero_count;
		//��������� ������
		ExplodedOBOZ = ExplodeOBOZ(OBOZ);
   		temp = ExplodedOBOZ.split(delimiter);
   		OBOZ_PREFIX = temp[0];
   		OBOZ_FIRST_NUM = temp[1];
   		OBOZ_SECOND_NUM = temp[2];
   		OBOZ_THERD_NUM = temp[3];
   		if(temp.length == 5) OBOZ_POSTFIX = temp[4];
   		 else OBOZ_POSTFIX = "";
		//�������� ������ ������������ �������
   	    SQLRequest sql = new SQLRequest();
   	    sql.GetAllOboznachenieFromCurrentOboznachenie(OBOZ_PREFIX, OBOZ_FIRST_NUM);
   	    while(sql.rs.next()){
   	    	OBOZFromDatabase = sql.rs.getString("OBOZ_PREFIX") + sql.rs.getString("OBOZ_FIRST_NUM") + sql.rs.getString("OBOZ_SECOND_NUM") + sql.rs.getString("OBOZ_THERD_NUM") + sql.rs.getString("OBOZ_POSTFIX");
   	    	OBOZFromDatabase = OBOZFromDatabase.trim();
   	    	UsedNumbers.add(OBOZFromDatabase);
   	    }
   		if(OBOZ_THERD_NUM.equals("000")){
  			//���������� ������ ������� �����
   			for(ii=0;ii<100;ii++){
   				GEN_OBOZ_FIRST_NUM = Integer.valueOf(ii).toString();
				//������� ������� ��� ����� �����
				plus_zero_count = 3 - GEN_OBOZ_FIRST_NUM.length();
				//��������� ��������������� ����� ������
				for(jj=1;jj<plus_zero_count;jj++){
				GEN_OBOZ_FIRST_NUM = "0" + GEN_OBOZ_FIRST_NUM;
				}
				//��������� ��������� ������
   				for(i=1;i<100;i++){
   					GEN_OBOZ_SECOND_NUM = Integer.valueOf(i).toString();
   					//������� ������� ��� ����� �����
   					plus_zero_count = 3 - GEN_OBOZ_SECOND_NUM.length();
   					//��������� ��������������� ����� ������
   					for(j=1;j<plus_zero_count;j++){
   					GEN_OBOZ_SECOND_NUM = "0" + GEN_OBOZ_SECOND_NUM;
   					}
   					//��������� ��������� ������
   					GenOboz = OBOZ_PREFIX + GEN_OBOZ_FIRST_NUM + GEN_OBOZ_SECOND_NUM + OBOZ_THERD_NUM + OBOZ_POSTFIX;
   					//��������� � ������ ����������
   					if(!UsedNumbers.contains(GenOboz)) ResultNumbers = ResultNumbers + GenOboz + " ";
   				}
   			}
   			return ResultNumbers;
   			
   		} else{
   			//���������� ������ ��������� �����
   			for(i=1;i<1000;i++){
   				GEN_OBOZ_THERD_NUM = Integer.valueOf(i).toString();
   				//������� ������� ��� ����� �����
   				plus_zero_count = 3 - GEN_OBOZ_THERD_NUM.length();
   				//��������� ��������������� ����� ������
   				for(j=0;j<plus_zero_count;j++){
   					GEN_OBOZ_THERD_NUM = "0" + GEN_OBOZ_THERD_NUM;
   				}
   				//��������� ��������� ������
   				GenOboz = OBOZ_PREFIX + OBOZ_FIRST_NUM + OBOZ_SECOND_NUM + GEN_OBOZ_THERD_NUM + OBOZ_POSTFIX;
   				//��������� � ������ ����������
   				if(!UsedNumbers.contains(GenOboz)) ResultNumbers = ResultNumbers + GenOboz + " ";				
   			}
   			return ResultNumbers;
   		}
	}
}
