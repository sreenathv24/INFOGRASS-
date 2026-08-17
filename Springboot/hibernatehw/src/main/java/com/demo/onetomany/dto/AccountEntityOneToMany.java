package com.demo.onetomany.dto;

import java.io.Serial;
import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity(name = "ForeignKeyAssoAccountEntity")
@Table(name = "ACCOUNT_1_M", uniqueConstraints = {
    @UniqueConstraint(columnNames = "ID")})
public class AccountEntityOneToMany implements Serializable {
	
	  @Serial
	  private static final long serialVersionUID = -6790693372846798580L;

	  @Id
	  @GeneratedValue(strategy = GenerationType.IDENTITY)
	  @Column(name = "ID", unique = true, nullable = false)
	  private Integer accountId;

	  @Column(name = "ACC_NUMBER", unique = true, nullable = false, length = 100)
	  private String accountNumber;

	  public Integer getAccountId() {
	    return accountId;
	  }

	  public void setAccountId(Integer accountId) {
	    this.accountId = accountId;
	  }

	  public String getAccountNumber() {
	    return accountNumber;
	  }

	  public void setAccountNumber(String accountNumber) {
	    this.accountNumber = accountNumber;
	  }

}
