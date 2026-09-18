using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Vitrify.API.Migrations
{
    /// <inheritdoc />
    public partial class AddJobImageTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ReplicateFileUrl",
                table: "JobItems");

            migrationBuilder.AddColumn<int>(
                name: "ImageIndex",
                table: "JobItems",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "JobImages",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    JobId = table.Column<Guid>(type: "uuid", nullable: false),
                    Index = table.Column<int>(type: "integer", nullable: false),
                    Base64Data = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_JobImages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_JobImages_Jobs_JobId",
                        column: x => x.JobId,
                        principalTable: "Jobs",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_JobImages_JobId",
                table: "JobImages",
                column: "JobId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "JobImages");

            migrationBuilder.DropColumn(
                name: "ImageIndex",
                table: "JobItems");

            migrationBuilder.AddColumn<string>(
                name: "ReplicateFileUrl",
                table: "JobItems",
                type: "text",
                nullable: true);
        }
    }
}
