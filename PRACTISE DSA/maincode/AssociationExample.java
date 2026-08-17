package javacode.maincode;

class Hospital {
    String name;

    Hospital(String name) {
        this.name = name;
    }
}

public class AssociationExample {
    String doctorName;
    Hospital hospital;

    AssociationExample(String doctorName, Hospital hospital) {
        this.doctorName = doctorName;
        this.hospital = hospital;
    }

    void show() {
        System.out.println(doctorName + " works at " + hospital.name);
    }

    public static void main(String[] args) {
        Hospital h = new Hospital("City Hospital");
        AssociationExample doctor = new AssociationExample("Dr. Sam", h);
        doctor.show();
    }
}
