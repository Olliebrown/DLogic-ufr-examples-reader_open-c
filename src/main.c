/*
 ============================================================================
 Name        : main.c
 Author      : Digital Logic
 Version     : 1.0
 Copyright   : 
 Description : Very simple test of uFR library
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <uFCoder.h>

/** Calls ReaderOpenEx() and print status */
UFR_STATUS reader_open_ex(uint32_t reader_type, c_string port_name,
		uint32_t port_interface, char *arg)
{
	UFR_STATUS status;

	status = ReaderOpenEx(reader_type, port_name, port_interface, arg);
	printf("ReaderOpenEx(%d, '%s', %d, 0):> %s\n", reader_type, port_name,
			port_interface, UFR_Status2String(status));

	if (status)
		return status;

	status = ReaderUISignal(3, 3);
	printf("ReaderUISignal(3, 3):> %s\n", UFR_Status2String(status));

	puts(GetReaderDescription());

	fflush(stdout);

	return status;
}

UFR_STATUS test_port_open_arg(void)
{
	UFR_STATUS status;
	int r;
	uint32_t reader_type = 1;
	char port_name[1024] = "";
	uint32_t port_interface = 2;
	char open_args[1024] = "";

	puts("Test opening Digital Logic uFR readers with ReaderOpenEx() !");

	//---

	printf("\n"
			"Parameter <reader_type>\n"
			"  Supported values: \n"
			"    0 : auto > same as call ReaderOpen()\n"
			"    1 : uFR type (1 Mbps)\n"
			"    2 : uFR RS232 type (115200 bps)\n"
			"    3 : XRC type (250 Kbps)\n"
			"Enter the first parameter <reader_type> [0,1,2,3, ...]: ");
	fflush(stdout);
	r = scanf("%d", &reader_type);
	printf("scanf()= %d\n", r);

	//---

	printf("\n"
			"Enter the parameter <port_name> [string]: ");
	fflush(stdout);
	r = scanf("%s", port_name);
	printf("scanf()= %d\n", r);

	//---

	printf("\n"
			"Parameter <port_interface> - type of communication interfaces\n"
			"  Supported values: \n"
			"    0 : auto - first try FTDI than serial if no port_name defined\n"
			"    1 : try serial / virtual COM port / interfaces\n"
			"    2 : try only FTDI communication interfaces\n"
			"    84 ('T') : TCP/IP interface\n"
			"    85 ('U') : UDP interface\n"
			"Enter the parameter <port_interface> [0, 1, 2, 84, 85,]: ");
	fflush(stdout);
	r = scanf("%d", &port_interface);
	printf("scanf()= %d\n", r);

	//---

	printf("\n"
			"Enter additional settings in c-string format to open uFR"
			"  Supported values\n"
			"    - READER_ACTIVE_ON_RTS_LOW (default)\n"
			"    - READER_ACTIVE_ON_RTS_HIGH\n"
			"    - RTS_ALWAYS_HIGH\n"
			"    - RTS_ALWAYS_LOW\n"
			"    - RTS_DISCONNECTED\n"
			"    --\n"
			"    - UNIT_OPEN_RESET_DISABLE\n"
			"    - UNIT_OPEN_RESET_FORCE\n"
			"Enter the parameter [string]: ");
	fflush(stdout);
	r = scanf("%s", open_args);
	printf("scanf()= %d\n", r);

	status = reader_open_ex(reader_type, port_name, port_interface, open_args);

	return status;
}

void test_list_readers(void)
{
	UFR_STATUS status;
	int num;

	status = ReaderList_UpdateAndGetCount(&num);

	printf("ReaderList_UpdateAndGetCount() = %s :: ",
			UFR_Status2String(status));
	if (status)
		return;

	printf("DEVICES= %d\n", num);

	fflush(stdout);
}

void test_ESP32_inet(int type)
{
	char ip_addr[64] = "192.168.1.68";
//	char port_src[16];
	char port_dst[16] = "8881";

	printf("Enter IP address [%s]: ", ip_addr);
	scanf("%s", ip_addr);

	printf("Enter destination port [8881/8882]: ");
	scanf("%s", port_dst);

//	printf("Enter source port: ");
//	scanf("%s", port_src);

	strcat(ip_addr, ":");
	strcat(ip_addr, port_dst);

	printf("test_ESP32_inet(%s | type: %d == %c)\n", ip_addr, type, type);
	fflush(stdout);

	reader_open_ex(0, ip_addr, type, 0);

	UFR_STATUS status;

	uint8_t data[16];
	uint8_t block_address = 2;
	uint8_t auth_mode = MIFARE_AUTHENT1A;
	const uint8_t key[6] =
	{ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };

	status = BlockRead_PK(data, block_address, auth_mode, key);
	printf("BlockRead_PK(...):> %s\n", UFR_Status2String(status));
}

/** test opening without reset/RTS on ESP32 - transparent mode 115200 */
void test_ESP32_trans(void)
{
	reader_open_ex(2, 0, 0, "UNIT_OPEN_RESET_DISABLE");
}

#define TEST_APP_VER	"2.0"

static const char choice_str[] = "Test opening Digital Logic reader:\n"
		"1) uFR nano 1 Mbps with FTDI I/F\n"
		"2) uFR nano RS232 115200 bps with serial I/F (auto port)\n"
		"3) uFR nano RS232 115200 bps with serial I/F (/dev/serial0)\n"
		"4) uFR RS232 115200 bps on RPi shield\n"
		"9) Multi-readers list\n"
		"10) uFR nano ESP32 UART - transparent mode\n"
		"11) uFR nano ESP32 UDP\n"
		"12) uFR nano ESP32 TCP/IP\n"
		"0) custom parameters in ReaderOpenEx()\n"
		"\n";

int main(void)
{
	UFR_STATUS status;
	int choice = -1;

	printf("\nTest ReaderOpen version %s\n", TEST_APP_VER);
	//--------------------------------------------------------------
	printf("* uFCoder library version: %s\n\n", GetDllVersionStr());
	//--------------------------------------------------------------
	puts(choice_str);

	printf("Enter number: ");
	fflush(stdout);
	//--------------------------------------------------------------
	scanf("%d", &choice);

//	printf("%d - %c\n", choice, choice);
//	fflush(stdout);

	switch (choice)
	{
	case 1:
		reader_open_ex(1, "", 2, 0);
		break;
	case 2:
		reader_open_ex(2, "", 0, 0);
		break;
	case 3:
		reader_open_ex(2, "/dev/serial0", 1, 0);
		break;
	case 4:
		reader_open_ex(2, "/dev/serial0", 10, 0);
		break;
	case 9:
		test_list_readers();
		break;
	case 10:
		test_ESP32_trans();
		break;
	case 11:
		test_ESP32_inet('U');
		break;
	case 12:
		test_ESP32_inet('T');
		break;

	default:
		test_port_open_arg();
		break;
	}

	/* exit */
	status = ReaderClose();
	printf("ReaderClose():> %s\n", UFR_Status2String(status));

	puts("Tester finish.");
	fflush(stdout);

	sleep(2);

	return EXIT_SUCCESS;
}
